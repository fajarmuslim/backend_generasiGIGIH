require_relative "person"

class Ally < Person
  def initialize(name, hitpoints, attack_damage)
    super(name, hitpoints, attack_damage)
    @deflect_percentage = 0.8
  end

  def healed_by_others(healing_points)
    @hitpoints += healing_points
  end
end