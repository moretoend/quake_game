# frozen_string_literal: true

class Player
  attr_reader :id, :score
  attr_accessor :name

  def initialize(id, name)
    @id = id
    @name = name
    @score = 0
  end

  def kill(player)
    @score += 1 if @id != player.id
  end

  def killed_by_world
    @score -= 1 if @score.positive?
  end
end
