require_relative "person"

class Hero < Person
  def initialize(name, hitpoints, attack_damage)
    super(name, hitpoints, attack_damage)
    @deflect_percentage = 0.8
    @healing_points = 20
  end

  def attacked_by_others(damage)
    if rand < @deflect_percentage
      puts "#{@name} deflects the attack."
    else
      @hitpoints -= damage
    end
  end

  def healing_others(other_hero)
    puts "#{@name} heals #{other_hero.name}, restoring #{@healing_points} hitpoints"
    other_hero.healed_by_others(@healing_points)
  end
end