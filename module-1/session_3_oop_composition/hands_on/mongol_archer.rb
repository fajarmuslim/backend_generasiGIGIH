require_relative 'villain'

class MongolArcher < Villain
  def attacking_other(other_person)
    puts "#{@name} shoots an arrow at #{other_person.name} with #{@attack_damage} damage."
    other_person.attacked_by_others(@attack_damage)
  end
end
