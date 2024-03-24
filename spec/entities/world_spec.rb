require 'spec_helper'
require 'quake_game/entities/world'

RSpec.describe World do
  describe '#kill' do
    subject { World.new(1022) }

    it 'makes victim to lose 1 point on score' do
      world_victim = Player.new(3, 'world victim')
      first_victim = Player.new(2, 'first victim')
      second_victim = Player.new(2, 'second victim')
      world_victim.kill(first_victim)
      world_victim.kill(second_victim)
      subject.kill(world_victim)
      expect(world_victim.score).to eq(1)
    end
  end
end
