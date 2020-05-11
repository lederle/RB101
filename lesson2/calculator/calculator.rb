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
  def self.compute(reader, writer)
  end

  class Writer
    def self.display_banner(os = $stdout)
    end
  end
end

require 'minitest/autorun'
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
  end

  class MockWriter

  end
end
