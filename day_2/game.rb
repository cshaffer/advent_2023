class Game
  attr_reader :id, :sets

  def initialize(id:, sets:)
    @id = id
    @sets = sets
  end

  def self.from_string(string)
    label, sets_string = string.split(':')
    id = label.split(' ').last.to_i
    sets = sets_string.split(';')
    new(id: id, sets: sets.map {|set| Set.from_string(set) })
  end

  def possible?(red:, blue:, green:)
    @sets.all? {|set| set.possible?(red: red, blue: blue, green: green) }
  end

  def minimum_set
    min_red = 0
    min_blue = 0
    min_green = 0
    @sets.each do |set|
      min_red = set.red if set.red > min_red
      min_blue = set.blue if set.blue > min_blue
      min_green = set.green if set.green > min_green
    end
    Set.new(red: min_red, blue: min_blue, green: min_green)
  end
end

class Set
  attr_reader :red, :blue, :green

  def initialize(red: 0, blue: 0, green: 0)
    @red = red
    @blue = blue
    @green = green
  end

  def self.from_string(string)
    cubes = string.split(',')
    red = 0
    blue = 0
    green = 0
    cubes.each do |cube|
      cube.chomp!
      cube.lstrip!
      count, color = cube.split(' ')
      red += count.to_i if color == 'red'
      blue += count.to_i if color == 'blue'
      green += count.to_i if color == 'green'
    end
    new(red: red, blue: blue, green: green)
  end

  def possible?(red:, blue:, green:)
    red >= @red && blue >= @blue && green >= @green
  end

  def power
    @red * @blue * @green
  end
end

class Games
  attr_reader :games

  def initialize(games:)
    @games = games
  end

  def self.from_file(path)
    games = File.readlines(path)
    new(games: games.map {|line| Game.from_string(line) })
  end

  def possible_games(red:, blue:, green:)
    @games.select {|game| game.possible?(red: red, blue: blue, green: green) }
  end

  def possible_game_id_sum(red:, blue:, green:)
    possible_games(red: red, blue: blue, green: green).inject(0) {|sum, game| sum += game.id }
  end

  def minimum_sets_sum
    @games.inject(0) {|sum, game| sum += game.minimum_set.power }
  end
end