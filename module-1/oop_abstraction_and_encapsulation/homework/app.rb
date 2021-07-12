require_relative 'player'

jin_sakai = Player.new("Jin Sakai", 100, 50)
khotun_khan = Player.new("Khotun Khan", 500, 50)

loop do
  jin_sakai.attacking_other(khotun_khan)
  break if khotun_khan.is_die?
  puts

  khotun_khan.attacking_other(jin_sakai)
  break if jin_sakai.is_die?
  puts
end

puts
puts "Jin Sakai dies" if jin_sakai.is_die?
puts "Khotun Khan dies" if khotun_khan.is_die?
