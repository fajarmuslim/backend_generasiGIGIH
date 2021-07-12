require_relative 'person'

class Hero < Person
  def initialize(name, hitpoints, attack_damage)
    super(name, hitpoints, attack_damage)
    @deflect_percentage = 0.8
  end

  def attacked_by_others(damage)
    if rand < @deflect_percentage
      puts "#{@name} deflects the attack."
    else
      @hitpoints -= damage
    end
  end
end
