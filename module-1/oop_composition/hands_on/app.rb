require_relative "hero"
require_relative "game"
require_relative "mongol_archer"
require_relative "mongol_swordsman"
require_relative "mongol_spearman"

jin_sakai = Hero.new("Jin Sakai", 100, 50)
yuna = Hero.new("Yuna", 90, 45)
sensei_ishikawa = Hero.new("Sensei Ishikawa", 80, 60)

mongol_archer = MongolArcher.new("Mongol Archer", 80, 40)
mongol_spearman = MongolSpearman.new("Mongol Spearman", 120, 60)
mongol_swordsman = MongolSwordsman.new("Mongol Swordsman", 100, 50)

playable_character = jin_sakai
non_playable_character = {heros:[yuna, sensei_ishikawa], villains:[mongol_archer, mongol_spearman, mongol_swordsman]}

game = Game.new(playable_character, non_playable_character)
game.start