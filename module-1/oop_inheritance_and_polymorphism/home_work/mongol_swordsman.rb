require_relative "villain"

class MongolSwordsman < Villain
  def attacking_other(other_person)
    puts "#{@name} slashes #{other_person.name} with #{@attack_damage} damage."
    other_person.attacked_by_others(@attack_damage)
  end
end