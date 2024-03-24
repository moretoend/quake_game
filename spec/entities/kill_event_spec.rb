require 'spec_helper'
require 'quake_game/entities/kill_event'

RSpec.describe KillEvent do
  describe '#initialize' do
    it 'raises an error when an invalid death cause is sent' do
      killer = Player.new(2, 'killer')
      victim = Player.new(3, 'victim')
      expect { described_class.new(killer, victim, 'invalid') }.to raise_error(described_class::InvalidEventError)
    end
  end
end
