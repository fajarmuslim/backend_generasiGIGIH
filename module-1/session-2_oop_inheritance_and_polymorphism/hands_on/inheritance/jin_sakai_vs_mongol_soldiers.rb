require_relative "hero"
require_relative "mongol_archer"
require_relative "mongol_swordsman"
require_relative "mongol_spearman"

jin_sakai = Hero.new("Jin Sakai", 100, 50)
mongol_archer = MongolArcher.new("Mongol Archer", 80, 40)
mongol_swordsman = MongolSwordsman.new("Mongol Swordsman", 100, 50)
mongol_spearman = MongolSpearman.new("Mongol Spearman", 120, 60)
villains = [mongol_archer, mongol_swordsman, mongol_spearman]

idx_turn = 1
until jin_sakai.is_die? || villains.empty?
  puts "============= Turn #{idx_turn} ============="
  puts

  puts jin_sakai
  villains.each do |villain|
    puts villain
  end
  puts

  jin_sakai.attacking_other(villains[rand(villains.size)])
  villains.each do |villain|
    villains.delete(villain) if villain.is_die? || villain.is_flee?
  end
  puts

  villains.each do |villain|
    villain.attacking_other(jin_sakai)
  end
  puts

  idx_turn += 1
end