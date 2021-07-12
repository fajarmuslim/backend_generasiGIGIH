class Game
  def initialize(playable_character, non_playable_character)
    @playable_character = playable_character
    @non_playable_character = non_playable_character
  end

  def remove_hero(hero)
    @non_playable_character[:heros].delete(hero)
  end

  def remove_villian(villain)
    @non_playable_character[:villains].delete(villain)
  end

  def start
    idx_turn = 1
    until (@playable_character.is_die? && @non_playable_character[:heros].empty?) || @non_playable_character[:villains].empty?
      print_characters_stats
      play_characters_turn(idx_turn)
      idx_turn += 1
    end
  end

  def print_characters_stats
    @playable_character.print_stats
    @non_playable_character.each_value do |grup|
      grup.each(&:print_stats)
    end
  end

  def print_playable_character_option
    puts 'As Jin Sakai, what do you want to do this turn'
    puts '1) Attack an enemy'
    puts '2) Heal an ally'
  end

  def print_idx_turn(idx_turn)
    puts "============= Turn #{idx_turn} ============="
    puts
  end

  def playable_character_attack
    puts '[if you pick 1]'
    puts 'which enemy you want to attack?'

    (0...@non_playable_character[:villains].size).each do |idx|
      puts "#{idx + 1}) #{@non_playable_character[:villains][idx].name}"
    end

    playable_character_choice_attack_villain = gets.chomp.to_i
    if playable_character_choice_attack_villain > @non_playable_character[:villains].size
      puts 'your input gonna wrong'
    else
      @playable_character.attacking_other(@non_playable_character[:villains][playable_character_choice_attack_villain - 1])
    end
  end

  def playable_character_heal
    puts '[if you pick 2]'
    puts 'which ally you want to heal?'

    (0...@non_playable_character[:heros].size).each do |idx|
      puts "#{idx + 1}) #{@non_playable_character[:heros][idx].name}"
    end

    playable_character_choice_heal_ally = gets.chomp.to_i

    if playable_character_choice_heal_ally > @non_playable_character[:heros].size
      puts 'your input gonna wrong'
    else
      @playable_character.healing_others(@non_playable_character[:heros][playable_character_choice_heal_ally - 1])
    end
  end

  def play_characters_turn(idx_turn)
    print_idx_turn(idx_turn)
    print_playable_character_option

    playable_character_choice = gets.chomp.to_i

    case playable_character_choice
    when 1
      playable_character_attack
    when 2
      playable_character_heal
    else
      puts 'your input gonna wrong'
    end

    @non_playable_character[:heros].each do |hero|
      hero.attacking_other(@non_playable_character[:villains][rand(@non_playable_character[:villains].size)])
    end

    @non_playable_character[:villains].each do |villain|
      remove_villian(villain) if villain.is_removed?
    end
    puts

    villains_enemy = if @playable_character.is_die?
                       @non_playable_character[:heros]
                     else
                       @non_playable_character[:heros] + [@playable_character]
                     end

    @non_playable_character[:villains].each do |villain|
      villain.attacking_other(villains_enemy[rand(villains_enemy.size)])
    end
    puts

    @non_playable_character[:heros].each do |hero|
      remove_hero(hero) if hero.is_removed?
    end
    puts
  end
end
