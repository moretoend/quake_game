require 'spec_helper'
require 'quake_game/entities/player'

RSpec.describe 'Player' do
  let(:killer) { Player.new(2, 'Killer') }

  describe '#kill' do
    it 'inscreases :score if the player had not killed himself' do
      victim = Player.new(3, 'Victim')
      killer.kill(victim)
      expect(killer.score).to eq(1)
    end

    it 'does not increase :score if the player killed himself' do
      killer.kill(killer)
      expect(killer.score).to eq(0)
    end

    it 'does not decrease :score if the player killed himself' do
      victim = Player.new(3, 'Victim')
      killer.kill(victim)
      killer.kill(killer)
      expect(killer.score).to eq(1)
    end
  end

  describe '#killed_by_world' do
    it 'decreases score if it is positive' do
      victim = Player.new(3, 'Victim')
      killer.kill(victim)
      killer.killed_by_world
      expect(victim.score).to eq(0)
    end

    it 'does not decrease score if it is equal to 0' do
      killer.killed_by_world
      expect(killer.score).to eq(0)
    end
  end
end
