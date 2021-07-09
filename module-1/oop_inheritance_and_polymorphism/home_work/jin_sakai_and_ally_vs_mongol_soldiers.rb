require_relative "hero"
require_relative "ally"
require_relative "mongol_archer"
require_relative "mongol_swordsman"
require_relative "mongol_spearman"

jin_sakai = Hero.new("Jin Sakai", 100, 50)
yuna = Ally.new("Yuna", 90, 45)
sensei_ishikawa = Ally.new("Sensei Ishikawa", 80, 60)
heros = [yuna, sensei_ishikawa]

mongol_archer = MongolArcher.new("Mongol Archer", 80, 40)
mongol_spearman = MongolSpearman.new("Mongol Spearman", 120, 60)
mongol_swordsman = MongolSwordsman.new("Mongol Swordsman", 100, 50)
villains = [mongol_archer, mongol_spearman, mongol_swordsman]

idx_turn = 1
until (heros.empty? && jin_sakai.is_die) || villains.empty?
    puts "============= Turn #{idx_turn} ============="
    puts

    heros.each do |hero|
        puts hero
    end
    
    villains.each do |villain|
        puts villain
    end
    puts
    
    puts "As Jin Sakai, what do you want to do this turn"
    puts "1) Attack an enemy"
    puts "2) Heal an ally"
    jin_sakai_choice = gets.chomp.to_i
    
    if jin_sakai_choice == 1
        puts "[if you pick 1]"
        puts "which enemy you want to attack?"
        
        for idx in 0 ... villains.size
            puts "#{idx + 1}) #{villains[idx].name}"
        end

        jin_sakai_choice_attack_villain = gets.chomp.to_i
        jin_sakai.attacking_other(villains[jin_sakai_choice_attack_villain-1])
    elsif jin_sakai_choice == 2
        puts "[if you pick 2]"
        puts "which ally you want to heal?"

        for idx in 0 ... heros.size
            puts "#{idx + 1}) #{heros[idx].name}"
        end

        jin_sakai_choice_heal_ally = gets.chomp.to_i
        jin_sakai.healing_others(heros[jin_sakai_choice_heal_ally-1])
    end

    heros.each do |hero|
        hero.attacking_other(villains[rand(villains.size)])
    end

    villains.each do |villain|
        villains.delete(villain) if villain.is_die? || villain.is_flee?
    end
    puts

    villains_enemy = []
    if jin_sakai.is_die?
        villains_enemy = heros
    else
        villains_enemy = heros + [jin_sakai]
    end

    villains.each do |villain|
        villain.attacking_other(villains_enemy[rand(villains_enemy.size)])
    end
    puts

    heros.each do |hero|
        heros.delete(hero) if hero.is_die?
    end
    puts
    
    idx_turn += 1
end