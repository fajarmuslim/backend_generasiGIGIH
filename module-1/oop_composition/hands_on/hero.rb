require_relative "person"

class Hero < Person
    def initialize(name, hitpoints, attack_damage)
        super(name, hitpoints, attack_damage)
        @deflect_percentage= 0.8
        @healing_points = 20
    end

    def deflect
        puts "#{@name} deflects the attack."
    end

    def attacked_by_others(damage)
        if rand < @deflect_percentage
            self.deflect
        else
            super(damage)
        end
    end

    def healing_others(other_hero)
        puts "#{@name} heals #{other_hero.name}, restoring #{@healing_points} hitpoints"
        other_hero.healed_by_others(@healing_points)
    end

    def healed_by_others(healing_points)
        @hitpoints += healing_points
    end

    def is_removed?
        self.is_die?
    end
end