# frozen_string_literal: true

class Match
  class DuplicatedParticipantError < StandardError; end
  class ParticipantNotFoundError < StandardError; end
  class WorldCannotBeKilledError < StandardError; end

  attr_reader :id, :world, :kill_events

  def initialize(id)
    @id = id
    @participants = []
    @kill_events = []
  end

  def world=(world_id)
    @world = World.new(world_id)
    @participants << @world
  end

  def add_player(id, name)
    found_player = @participants.index { |participant| participant.id == id }
    @participants << Player.new(id, name) unless found_player
  end

  def update_player(id, name)
    found_player = find_participant_by_id(id)
    found_player.name = name
  end

  def add_kill_event(killer_id, victim_id, death_cause)
    killer = find_participant_by_id(killer_id)
    victim = find_participant_by_id(victim_id)
    raise WorldCannotBeKilledError, 'World cannot be killed' if victim == @world

    killer.kill(victim)
    @kill_events << KillEvent.new(killer, victim, death_cause)
  end

  def players
    @participants - [@world]
  end

  def total_kills
    @kill_events.size
  end

  private

  def find_participant_by_id(id)
    index = @participants.index { |participant| participant.id == id }
    raise ParticipantNotFoundError, "Participant with id #{id} not found" if index.nil?

    @participants[index]
  end
end
