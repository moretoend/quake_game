require 'spec_helper'
require 'quake_game/entities/match'

RSpec.describe Match do
  subject { Match.new(1) }

  describe '#world=' do
    it 'instanciates a World with given id' do
      subject.world = 'world'
      expect(subject.world).to be_a World
      expect(subject.world.id).to eq 'world'
    end
  end

  describe '#add_player' do
    it 'adds a Player to the match' do
      subject.add_player(2, 'player2')
      found_player = subject.players.index { |player| player.id == 2 }
      expect(found_player).not_to be_nil
    end

    it 'raises and error if Player already exist' do
      subject.add_player(2, 'player2')
      expect { subject.add_player(2, 'player2') }.to raise_error(described_class::DuplicatedParticipantError)
    end
  end

  describe '#add_kill_event' do
    it 'raises an error if killer does not exist' do
      subject.add_player(1, 'player1')
      expect { subject.add_kill_event(2, 1, 'MOD_SHOTGUN') }.to raise_error(described_class::ParticipantNotFoundError)
    end

    it 'raises an error if victim does not exist' do
      subject.add_player(1, 'player1')
      expect { subject.add_kill_event(1, 2, 'MOD_SHOTGUN') }.to raise_error(described_class::ParticipantNotFoundError)
    end

    it 'raises an error if death cause does not exist' do
      subject.add_player(1, 'player1')
      subject.add_player(2, 'player2')
      expect { subject.add_kill_event(1, 2, 'invalid') }.to raise_error(KillEvent::InvalidEventError)
    end

    it 'raises an error if world is a victim' do
      subject.world = 'world'
      subject.add_player(1, 'player1')
      expect { subject.add_kill_event(1, 'world', 'MOD_SHOTGUN') }.to raise_error(described_class::WorldCannotBeKilledError)
    end

    it 'adds a new kill event to the match when a player kills another' do
      subject.add_player(1, 'player1')
      subject.add_player(2, 'player2')
      subject.add_kill_event(1, 2, 'MOD_SHOTGUN')
      found_kill_event = subject.kill_events.index do |kill_event|
        kill_event.killer.id == 1 && kill_event.victim.id == 2 && kill_event.death_cause == 'MOD_SHOTGUN'
      end
      expect(found_kill_event).not_to be_nil
    end

    it 'adds a new kill event to the match when the world kills a player' do
      subject.world = 'world'
      subject.add_player(1, 'player1')
      subject.add_kill_event('world', 1, 'MOD_TRIGGER_HURT')
      found_kill_event = subject.kill_events.index do |kill_event|
        kill_event.killer.id == 'world' && kill_event.victim.id == 1 && kill_event.death_cause == 'MOD_TRIGGER_HURT'
      end
      expect(found_kill_event).not_to be_nil
    end

    it 'adds a new kill event to the match when a player kills itself' do
      subject.add_player(1, 'player1')
      subject.add_kill_event(1, 1, 'MOD_SUICIDE')
      found_kill_event = subject.kill_events.index do |kill_event|
        kill_event.killer.id == 1 && kill_event.victim.id == 1 && kill_event.death_cause == 'MOD_SUICIDE'
      end
      expect(found_kill_event).not_to be_nil
    end

    it 'increases killer score' do
      subject.add_player(1, 'player1')
      subject.add_player(2, 'player2')
      subject.add_kill_event(1, 2, 'MOD_SHOTGUN')
      expect(subject.players.first.score).to eq 1
    end
  end

  describe '#total_kills' do
    it 'returns the total number of kills' do
      subject.world = 'world'
      subject.add_player(1, 'player1')
      subject.add_player(2, 'player2')
      subject.add_kill_event(1, 2, 'MOD_SHOTGUN')
      subject.add_kill_event(2, 1, 'MOD_SHOTGUN')
      subject.add_kill_event(1, 1, 'MOD_SHOTGUN')
      subject.add_kill_event('world', 2, 'MOD_SHOTGUN')
      expect(subject.total_kills).to eq 4
    end
  end
end
