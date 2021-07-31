class IntegerArrayIncrement
  def increment(input)
    num = 0
    input.each do |item|
      num *= 10
      num += item
    end

    num += 1
    output = []

    while num != 0 do
      output.append(num % 10)
      num /= 10
    end

    output.reverse
  end
end