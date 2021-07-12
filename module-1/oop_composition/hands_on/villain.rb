require_relative "person"

class Villain < Person
    def initialize(name, hitpoints, attack_damage)
        super(name, hitpoints, attack_damage)
        @fleed_percentage = 0.5
        @fleed = false
    end

    def attacked_by_others(damage)
        super(damage)
        if @hitpoints <= 50
            flee if rand < @fleed_percentage
        end
    end

    def flee
        @fleed = true
        puts "#{@name} has fleed the battlefield with #{@hitpoints} hitpoints left"
    end

    def is_flee?
        @fleed
    end
    
    def is_removed?
        self.is_die? || self.is_flee?
    end
end