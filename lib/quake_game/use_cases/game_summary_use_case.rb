require 'quake_game/entities/match'

class GameSummaryUseCase
  def initialize(log_reader_adapter)
    @log_reader_adapter = log_reader_adapter
    @matches = []
  end

  def call(log_file_path)
    load_data_from_log_file(log_file_path)
    response = { 'matches' => {}, 'rankings' => {} }
    @matches.each do |match|
      response['matches'].merge! build_summmary_response(match)
      response['rankings'].merge! build_ranking_response(match)
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

    @log_reader_adapter.subscribe_on(:player_update) do |player_id, new_name|
      current_match.update_player(player_id, new_name)
    end

    @log_reader_adapter.subscribe_on(:kill) do |killer_id, victim_id, death_cause|
      current_match.add_kill_event(killer_id, victim_id, death_cause)
    end

    @log_reader_adapter.call(log_file_path)
  end

  def build_summmary_response(match)
    {
      "game_#{match.id}" => {
        'total_kills' => match.total_kills,
        'players' => match.players.map(&:name),
        'kills' => match.players.to_h { |player| [player.name, player.score] }
      }
    }
  end

  def build_ranking_response(match)
    ranking = match.players.sort_by(&:score).reverse.map do |player|
      { 'name' => player.name, 'score' => player.score }
    end

    { "game_#{match.id}" => ranking }
  end
end
