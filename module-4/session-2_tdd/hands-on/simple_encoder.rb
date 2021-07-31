class SimpleEncoder

  MAX_ORD = 'z'.ord
  MIN_ORD = 'a'.ord
  VOWEL_CHARS = ['a', 'i', 'u', 'e', 'o']

  def encode(input)
    output = ''
    input.each_char do |character|
      if VOWEL_CHARS.include? character
        ord = character.ord
        new_ord = ord - 5
        if new_ord < MIN_ORD
          diff = MIN_ORD - new_ord
          new_ord = MAX_ORD - diff + 1
        end
        output << new_ord.chr
      elsif character != ''
        ord = character.ord
        new_ord = ord + 9
        if new_ord > MAX_ORD
          diff = new_ord - MAX_ORD
          new_ord = MIN_ORD + diff - 1
        end
        output << new_ord.chr
      end
    end
    output
  end
end