# frozen_string_literal: true

require 'pry'

def calculator(reader = Reader, writer = Writer)
  writer.display_banner
  writer.ask_for_number(:first)
  until (num1 = reader.read_num)
    writer.display_invalid_number
    writer.ask_for_number(:first)
  end
  writer.ask_for_number(:second)
  until (num2 = reader.read_num)
    writer.display_invalid_number
    writer.ask_for_number(:second)
  end
  writer.ask_for_operation
  operation = reader.read_op
  case operation
  when '1'
    writer.display_result calculate(num1, num2, :+)
  when '2'
    writer.display_result calculate(num1, num2, :-)
  when '3'
    writer.display_result calculate(num1, num2, :*)
  when '4'
    writer.display_result calculate(num1, num2, :/)
  end
end

def calculate(num1, num2, oper)
  if oper.to_s == '/'
    num1 = num1.to_f
    num2 = num2.to_f
  else
    num1 = num1.to_i
    num2 = num2.to_i
  end
  num1.send(oper, num2)
end

# Reader is a helper class for the calculator
# function. The default parameter is $stdin
# but its main reason to be is to allow a
# fake reader to by substituted during testing.
# It performs the gets operations for the
# calculator.
class Reader
  def self.read_num(i_stream = $stdin)
    input = i_stream.gets.chomp
    valid?(input) && input
  end

  def self.read_op(i_stream = $stdin)
    i_stream.gets.chomp
  end
end

class << Reader
  private

  def valid?(num)
    num.to_i != 0
  end
end

# Writer is a helper class for the calculator
# function. The default parameter is $stdout
# but its main reason to be is to allow a
# fake writer to by substituted during testing.
# It performs the puts-related operations
# for calculator.
class Writer
  def self.display_banner(o_stream = $stdout)
    o_stream.puts decorate('Welcome to Calculator!')
  end

  def self.ask_for_number(o_stream = $stdout, term)
    # Note to self: symbol auto converts to string
    o_stream.puts decorate("What's the #{term} number?")
  end

  def self.ask_for_operation(o_stream = $stdout)
    o_stream.puts decorate('What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide')
  end

  def self.display_result(o_stream = $stdout, res)
    o_stream.puts decorate("The result is #{res}")
    res
  end

  def self.display_invalid_number(o_stream = $stdout)
    o_stream.puts decorate("Hmm... that doesn't look like a valid number")
  end
end

# This is a semi-hack for now, it creates a private
# class method. My intent was to add decorate
# as a private instance method and just use
# it within Writer, but I get NoMethodError
# when used this way, I'm not understanding
# something about class methods and I can't
# ferret out an SO post that covers this
# particular situation. The hack does provide the
# desired intent, no one can use decorate except
# Writer members. Why? I didn't like the idea of
# calculator using decorate, it feels more
# appropriate in the domain of Writer.
class << Writer
  private

  def decorate(message)
    '=> ' + message
  end
end

require 'minitest/autorun'
# Test the Reader; use a StringIO
# to fake $stdin
class ReaderTest < Minitest::Test
  def read_num(input)
    @stream = StringIO.new input
    Reader.read_num @stream
  end

  def read_op(input)
    @stream = StringIO.new input
    Reader.read_op @stream
  end

  def test_read_a_number
    assert_equal '10', read_num('10')
  end

  def test_read_not_a_number
    refute read_num('m')
  end

  def test_read_not_a_number_check_not_nil
    refute_nil read_num('m')
  end

  def test_zero
    refute read_num('0')
  end

  def test_read_an_op
    assert_equal '1', read_op('1')
  end
end

# Test the Writer; use a StringIO
# to fake $stdout. Much of the goings-on
# here seem useless, or simply testing
# the IO functionality, but if you testing
# first, theses tests form a "are the messages
# as wanted" spec of sorts.
class WriterTest < Minitest::Test
  def setup
    @stream = StringIO.new
    @writer = Writer
  end

  def test_display_banner
    @writer.display_banner @stream
    @stream.rewind
    expected = <<~OUT
      => Welcome to Calculator!
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_first_number
    @writer.ask_for_number @stream, :first
    @stream.rewind
    expected = <<~OUT
      => What's the first number?
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_second_number
    @writer.ask_for_number @stream, :second
    @stream.rewind
    expected = <<~OUT
      => What's the second number?
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_operation
    @writer.ask_for_operation @stream
    @stream.rewind
    expected = <<~OUT
      => What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_result
    res = 22
    out = @writer.display_result @stream, res
    @stream.rewind
    expected = <<~OUT
      => The result is 22
    OUT
    assert_equal expected, @stream.read
    assert_equal 22, out
  end

  def test_display_invalid_number
    @writer.display_invalid_number @stream
    @stream.rewind
    expected = <<~OUT
      => Hmm... that doesn't look like a valid number
    OUT
    assert_equal expected, @stream.read
  end
end

# Test the calculator; I consider these
# integration type tests, where the
# overall behavior of the calculator
# is what is interesting, not the line
# to line IO (ReaderTest and WriterTest
# do that). DIY mocks are used (I am
# still a little confused by Minitest::Mocks
# honestly), we are mostly interested
# in the return value from calculator.
class CalculatorTest < Minitest::Test
  def setup
    @reader = MockReader.new
    @writer = MockWriter.new
  end

  def test_happy
    @reader.responses = %w[1 2 1]
    assert_equal 3, calculator(@reader, @writer)
  end

  def test_subtract
    @reader.responses = %w[23 12 2]
    assert_equal 11, calculator(@reader, @writer)
  end

  def test_product
    @reader.responses = %w[23 2 3]
    assert_equal 46, calculator(@reader, @writer)
  end

  def test_quotient
    @reader.responses = %w[23 2 4]
    assert_equal 11.5, calculator(@reader, @writer)
  end

  def test_bad_input_first_number
    @reader.responses = %w[nan 23 2 1]
    assert_equal 25, calculator(@reader, @writer)
    assert_equal 3, @reader.num_read_count
  end

  def test_bad_input_second_number
    @reader.responses = %w[23 nan 2 1]
    assert_equal 25, calculator(@reader, @writer)
    assert_equal 3, @reader.num_read_count
  end

  def test_multiple_bad_input_first_number
    @reader.responses = %w[ds sdf sdf sdf ff nan 23 2 1]
    assert_equal 25, calculator(@reader, @writer)
    assert_equal 8, @reader.num_read_count
  end

  def test_multiple_bad_input_second_number
    @reader.responses = %w[23 nan nan 2 1]
    assert_equal 25, calculator(@reader, @writer)
    assert_equal 4, @reader.num_read_count
  end

  def test_bad_input_both_first_and_second
    @reader.responses = %w[nan 23 nan nan 2 1]
    assert_equal 25, calculator(@reader, @writer)
    assert_equal 5, @reader.num_read_count
  end

  def test_noop
    @reader.responses = %w[23 2 999]
    assert_nil calculator(@reader, @writer)
  end

  def test_calculate
    assert_equal 2, calculate('1', '1', :+)
    assert_equal 0, calculate('1', '1', :-)
    assert_equal 1, calculate('1', '1', :*)
    assert_equal 1.0, calculate('1', '1', :/)
  end

  # Fake Reader class. To mimic a stream
  # of input from user, an array is used
  # and individual inputs are shifted off
  # for use in the test.
  class MockReader
    attr_accessor :responses, :num_read_count

    def initialize
      self.num_read_count = 0
    end

    # don't want logic here, but all I can see
    # is either move Reader#valid? to calculator
    # or this(?)
    def read_num
      self.num_read_count += 1
      input = responses.shift
      return false if input.to_i.zero?

      input
    end

    def read_op
      responses.shift
    end
  end

  # Fake Writer class. We don't want to
  # write anything, just test end-to-end
  # behavior, so most of these are empty
  # methods. The display_results method
  # does need to return the result.
  class MockWriter
    def display_banner; end

    def ask_for_number(term); end

    def ask_for_operation; end

    def display_result(res)
      res
    end

    def display_invalid_number; end
  end
end
