class Person
    attr_reader :name #getter for state name
    
    def initialize(name, hitpoints, attack_damage)
        @name = name
        @hitpoints = hitpoints
        @attack_damage = attack_damage
    end

    def to_s
        return "#{@name} has #{@hitpoints} hitpoints and #{@attack_damage} attack damage."
    end
 
    def attacking_other(other_person)
        puts "#{@name} attacks #{other_person.name} with #{@attack_damage} damage."
        other_person.attacked_by_others(@attack_damage)
    end
    
    def attacked_by_others(damage)
        @hitpoints -= damage
    end
 
    def is_die?
        if @hitpoints <= 0
            puts "#{@name} dies"
            true
        end
    end

    def print_stats
        self.to_s
    end
end