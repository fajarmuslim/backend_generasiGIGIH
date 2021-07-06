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
        if self.name == "Jin Sakai" # jin sakai has ability to deflect the attack
            if rand > 0.8 # doesn't deflect the attack
                @hitpoints -= damage
            else # deflect the attack
                puts "Jin Sakai deflects the attack."
            end
        else # others players doesn't has ability to deflect the attack
            @hitpoints -= damage
        end
        puts self
    end
 
    def is_die?
        return @hitpoints <= 0
    end
end