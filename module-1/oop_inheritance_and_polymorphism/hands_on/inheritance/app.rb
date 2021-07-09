require_relative "person"
require_relative "hero"

jin_sakai = Hero.new("Jin Sakai", 100, 50)
puts jin_sakai
puts

khotun_khan = Person.new("Khotun Khan", 500, 50)
puts khotun_khan
puts

loop do 
    jin_sakai.attacking_other(khotun_khan)
    puts khotun_khan
    puts
    break if khotun_khan.is_die? 

    khotun_khan.attacking_other(jin_sakai)
    puts jin_sakai
    puts
    break if jin_sakai.is_die? 
end