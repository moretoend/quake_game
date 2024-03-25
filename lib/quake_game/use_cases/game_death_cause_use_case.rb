require 'quake_game/entities/match'

class GameDeathCauseUseCase
  def initialize(log_reader_adapter)
    @log_reader_adapter = log_reader_adapter
    @matches = []
  end

  def call(log_file_path)
    load_data_from_log_file(log_file_path)
    response = {}
    @matches.each do |match|
      response.merge! summarize_death_cause(match)
    end
    response
  end

  private

  def load_data_from_log_file(log_file_path)
    current_match = nil

    @log_reader_adapter.subscribe_on(:match_start) do
      current_match = Match.new(@matches.size + 1)
      current_match.world = 1022
      @matches << current_match
    end

    @log_reader_adapter.subscribe_on(:player_join) do |player_id|
      current_match.add_player(player_id, nil)
    end

    @log_reader_adapter.subscribe_on(:kill) do |killer_id, victim_id, death_cause|
      current_match.add_kill_event(killer_id, victim_id, death_cause)
    end

    @log_reader_adapter.call(log_file_path)
  end

  def summarize_death_cause(match)
    sorted_means = match.kill_events.group_by(&:death_cause).transform_values(&:size)
    {
      "game_#{match.id}" => {
        'kills_by_means' => sorted_means.to_h
      }
    }
  end
end
