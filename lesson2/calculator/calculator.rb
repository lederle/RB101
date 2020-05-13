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
    writer.ask_for_number(:first)
    num1 = reader.read_num
    writer.ask_for_number(:second)
    num2 = reader.read_num
    writer.ask_for_operation
    operation = reader.read_op
    if operation == '1'
      writer.display_result calculate(num1, num2, :+)
    elsif operation == '2'
      writer.display_result calculate(num1, num2, :-)
    elsif operation == '3'
      writer.display_result calculate(num1, num2, :*)
    elsif operation == '4'
      writer.display_result calculate(num1, num2, :/)
    end
  end

  def self.calculate(num1, num2, oper)
    if oper.to_s == '/'
      num1 = num1.to_f
      num2 = num2.to_f
    else
      num1 = num1.to_i
      num2 = num2.to_i
    end
    num1.send(oper, num2)
  end

  class Reader
    def self.read_num(is = $stdin)
      is.gets.chomp
    end

    def self.read_op(is = $stdin)
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

    def self.ask_for_operation(os = $stdout)
      os.puts "What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide"
    end

    def self.display_result(os = $stdout, res)
      os.puts "The result is #{res}"
      res
    end
  end
end

require 'minitest/autorun'
class ReaderTest < Minitest::Test
  def read_num(input)
    @stream = StringIO.new input
    Calculator::Reader.read_num @stream
  end

  def read_op(input)
    @stream = StringIO.new input
    Calculator::Reader.read_op @stream
  end

  def test_read_a_number
    assert_equal '10', read_num('10')
  end

  def test_read_not_a_number
    assert_equal 'm', read_num('m')
  end

  def test_read_an_op
    assert_equal '1', read_op('1')
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

  def test_ask_for_operation
    @writer.ask_for_operation @stream
    @stream.rewind
    expected =<<~OUT
      What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_result
    res = 22
    out = @writer.display_result @stream, res
    @stream.rewind
    expected =<<~OUT
      The result is 22
    OUT
    assert_equal expected, @stream.read
    assert_equal 22, out
  end
end

class CalculatorTest < Minitest::Test
  def setup
    @reader = MockReader.new
    @writer = MockWriter.new
  end

  def test_happy
    @reader.responses = %w[1, 2, 1]
    assert_equal 3, Calculator.compute(@reader, @writer)
  end

  def test_subtract
    @reader.responses = %w[23, 12, 2]
    assert_equal 11, Calculator.compute(@reader, @writer)
  end

  def test_product
    @reader.responses = %w[23, 2, 3]
    assert_equal 46, Calculator.compute(@reader, @writer)
  end

  def test_quotient
    @reader.responses = %w[23, 2, 4]
    assert_equal 11.5, Calculator.compute(@reader, @writer)
  end

  def test_noop
    @reader.responses = %w[23, 2, 999]
    assert_nil Calculator.compute(@reader, @writer)
  end

  def test_calculate
    assert_equal 2, Calculator.calculate('1', '1', :+)  
    assert_equal 0, Calculator.calculate('1', '1', :-)
    assert_equal 1, Calculator.calculate('1', '1', :*)
    assert_equal 1.0, Calculator.calculate('1', '1', :/)
  end

  class MockReader
    attr_accessor :responses

    def read_num
      responses.shift
    end

    def read_op
      responses.shift
    end
  end

  class MockWriter
    def display_banner
    end

    def ask_for_number(term)
    end

    def ask_for_operation
    end

    def display_result res
      res
    end
  end
end
