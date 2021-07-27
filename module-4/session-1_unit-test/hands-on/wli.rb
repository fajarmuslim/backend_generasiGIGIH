class WLI
  attr_accessor :names

  def initialize
    @names = []
  end

  def like_this
    return 'no one likes this' if names.length == 0
    return "#{names[0]} likes this" if names.length == 1
    return "#{names[0]} and #{names[1]} like this" if names.length == 2
    return "#{names[0]}, #{names[1]} and #{names[2]} like this" if names.length == 3

    "#{names[0]}, #{names[1]} and #{names.length - 2} others like this"
  end
end