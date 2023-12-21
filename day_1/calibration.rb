class Calibration
  NUMBER_WORDS = %w(zero one two three four five six seven eight nine)

  def initialize(lines: )
    @lines = lines
  end

  def self.from_document(path)
    new(lines: File.readlines(path))
  end

  def sum_of_values
    @lines.inject(0) do |sum, line|
      sum += retrieve_value(line: line)
    end
  end

  private

  def retrieve_value(line:)
    (first_digit(line: line) + last_digit(line: line)).to_i
  end

  def first_digit(line:)
    index = 0
    while index < line.length do
      return line[index] if line[index].match? /\d/
      starting_number = starting_number_word(line: line[index..])
      return starting_number.to_s unless starting_number.nil?
      index += 1
    end
  end

  def starting_number_word(line:)
    NUMBER_WORDS.find_index do |number_word|
      line.start_with?(number_word)
    end
  end

  def ending_number_word(line:)
    NUMBER_WORDS.find_index do |number_word|
      line.end_with?(number_word)
    end
  end

  def last_digit(line:)
    index = line.length - 1
    while index >= 0 do
      return line[index] if line[index].match? /\d/
      ending_number = ending_number_word(line: line[..index])
      return ending_number.to_s unless ending_number.nil?
      index -= 1
    end
  end
end