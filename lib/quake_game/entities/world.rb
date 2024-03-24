# frozen_string_literal: true

class World
  def initialize(id)
    @id = id
  end

  def kill(player)
    player.killed_by_world
  end
end
