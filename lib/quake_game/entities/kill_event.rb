# frozen_string_literal: true

class KillEvent
  class InvalidEventError < StandardError; end

  attr_reader :killer, :victim, :death_cause

  AVAILABLE_DEATH_CAUSES = %w[
    MOD_UNKNOWN MOD_SHOTGUN MOD_GAUNTLET MOD_MACHINEGUN MOD_GRENADE MOD_GRENADE_SPLASH MOD_ROCKET MOD_ROCKET_SPLASH
    MOD_PLASMA MOD_PLASMA_SPLASH MOD_RAILGUN MOD_LIGHTNING MOD_BFG MOD_BFG_SPLASH MOD_WATER MOD_SLIME MOD_LAVA MOD_CRUSH
    MOD_TELEFRAG MOD_FALLING MOD_SUICIDE MOD_TARGET_LASER MOD_TRIGGER_HURT MOD_NAIL MOD_CHAINGUN MOD_PROXIMITY_MINE
    MOD_KAMIKAZE MOD_JUICED MOD_GRAPPLE
  ].freeze

  def initialize(killer, victim, death_cause)
    raise InvalidEventError unless AVAILABLE_DEATH_CAUSES.include?(death_cause)

    @killer = killer
    @victim = victim
    @death_cause = death_cause
  end
end
