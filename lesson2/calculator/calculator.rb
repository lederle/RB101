# puts "Welcome to the Calculator!"
# puts "What is your first number:"
# num1 = gets.chomp
# puts "What is your second number:"
# num2 = gets.chomp
# puts "What is the operation you wish to perform: " \
#      "(add)ition, (sub)traction, (mult)iplication or (div)ision"
# op = gets.chomp
# 
# result = if op == 'add'
#            num1.to_i + num2.to_i
#          elsif op == 'sub'
#            num1.to_i - num2.to_i
#          elsif op == 'mult'
#            num1.to_i * num2.to_i
#          else
#            num1.to_f / num2.to_f
#          end
# 
# puts result

class Calculator
  def self.compute(reader = Reader, writer = Writer)
    writer.display_banner
    writer.ask_for_number
    num1 = reader.read
  end

  class Reader
    def self.read(is = $stdin)
      is.gets.chomp
    end
  end

  class Writer
    def self.display_banner(os = $stdout)
      os.puts 'Welcome to Calculator!'
    end

    def self.ask_for_number(os = $stdout, term)
      os.puts "What's the #{term.to_s} number?"
    end
  end
end

require 'minitest/autorun'
class ReaderTest < Minitest::Test
  def read(input)
    @stream = StringIO.new input
    Calculator::Reader.read @stream
  end

  def test_a_number
    assert_equal '3', read('3')
  end

  def test_not_a_number
    assert_equal 'm', read('m')
  end
end

class WriterTest < Minitest::Test
  def setup
    @stream = StringIO.new
    @writer = Calculator::Writer
  end

  def test_display_banner
    @writer.display_banner @stream
    @stream.rewind
    expected =<<~OUT
      Welcome to Calculator!
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_first_number
    @writer.ask_for_number @stream, :first
    @stream.rewind
    expected =<<~OUT
      What's the first number?
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_second_number
    @writer.ask_for_number @stream, :second
    @stream.rewind
    expected =<<~OUT
      What's the second number?
    OUT
    assert_equal expected, @stream.read
  end
end

class CalculatorTest < Minitest::Test
  def setup
    @reader = MockReader.new
    @writer = MockWriter.new
  end

  def test_happy
    @reader.responses = [1, 2, '1']
    assert_equal 3, Calculator.compute(@reader, @writer)
  end

  class MockReader
    attr_accessor :responses

    def read
      responses.shift
    end
  end

  class MockWriter
    def display_banner
    end

    def ask_for_number
    end

  end
end
