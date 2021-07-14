class Player
  attr_reader :name #getter for state name

  def initialize(name, hitpoints, attack_damage)
    @name = name
    @hitpoints = hitpoints
    @attack_damage = attack_damage
  end

  def to_s
    return "#{@name} has #{@hitpoints} hitpoints and #{@attack_damage} attack damage."
  end

  def attacking_other(other_knight)
    puts "#{@name} attacks #{other_knight.name} with #{@attack_damage} damage."
    other_knight.attacked_by_others(@attack_damage)
  end

  def attacked_by_others(damage)
    @hitpoints -= damage
    puts self
  end

  def is_die?
    return @hitpoints <= 0
  end
end