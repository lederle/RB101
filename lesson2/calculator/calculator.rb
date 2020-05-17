# frozen_string_literal: true

require 'pry'
require_relative 'reader'
# do arithmetic on two numbers, over and over
# if you want
def calculator(reader = Reader, writer = Writer)
  ret = []
  writer.display_banner
  loop do
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
    res = case operation
          when '1'
            writer.display_result calculate(num1, num2, :+)
          when '2'
            writer.display_result calculate(num1, num2, :-)
          when '3'
            writer.display_result calculate(num1, num2, :*)
          when '4'
            writer.display_result calculate(num1, num2, :/)
          end
    ret.push(res)
    writer.ask_for_new_calc
    new_calc = reader.read_new_calc
    break unless new_calc == 'y'
  end
  writer.display_goodbye
  ret
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

# Writer is a helper class for the calculator
# function. The default parameter is $stdout
# but its main reason to be is to allow a
# fake writer to by substituted during testing.
# It performs the puts-related operations
# for calculator.
class Writer
  def self.display_banner(o_stream = $stdout)
    o_stream.puts decorate('Welcome to Calculator! Enter your name:')
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

  def self.ask_for_new_calc(o_stream = $stdout)
    o_stream.puts decorate('Do you want to perform another calculation? (Y to calculate again)')
  end

  def self.display_goodbye(o_stream = $stdout)
    o_stream.puts decorate('Thank you for using the calculator. Good bye!')
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

  def read_new_calc(input)
    @stream = StringIO.new input
    Reader.read_new_calc @stream
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

  def test_read_a_no_op
    assert_equal '11', read_op('11')
  end

  def test_read_new_calc_yes
    assert_equal 'y', read_new_calc('y')
  end

  def test_read_new_calc_capital_y
    assert_equal 'y', read_new_calc('Y')
  end

  def test_read_new_calc_no
    assert_equal 'n', read_new_calc('n')
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
      => Welcome to Calculator! Enter your name:
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

  def test_ask_for_another_calculation
    @writer.ask_for_new_calc @stream
    @stream.rewind
    expected = <<~OUT
      => Do you want to perform another calculation? (Y to calculate again)
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_goodbye
    @writer.display_goodbye @stream
    @stream.rewind
    expected = <<~OUT
      => Thank you for using the calculator. Good bye!
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
    assert_equal [3], calculator(@reader, @writer)
  end

  def test_subtract
    @reader.responses = %w[23 12 2]
    assert_equal [11], calculator(@reader, @writer)
  end

  def test_product
    @reader.responses = %w[23 2 3]
    assert_equal [46], calculator(@reader, @writer)
  end

  def test_quotient
    @reader.responses = %w[23 2 4]
    assert_equal [11.5], calculator(@reader, @writer)
  end

  def test_bad_input_first_number
    @reader.responses = %w[nan 23 2 1]
    assert_equal [25], calculator(@reader, @writer)
    assert_equal 3, @reader.num_read_count
  end

  def test_bad_input_second_number
    @reader.responses = %w[23 nan 2 1]
    assert_equal [25], calculator(@reader, @writer)
    assert_equal 3, @reader.num_read_count
  end

  def test_multiple_bad_input_first_number
    @reader.responses = %w[ds sdf sdf sdf ff nan 23 2 1]
    assert_equal [25], calculator(@reader, @writer)
    assert_equal 8, @reader.num_read_count
  end

  def test_multiple_bad_input_second_number
    @reader.responses = %w[23 nan nan 2 1]
    assert_equal [25], calculator(@reader, @writer)
    assert_equal 4, @reader.num_read_count
  end

  def test_bad_input_both_first_and_second
    @reader.responses = %w[nan 23 nan nan 2 1]
    assert_equal [25], calculator(@reader, @writer)
    assert_equal 5, @reader.num_read_count
  end

  def test_noop
    @reader.responses = %w[23 2 999]
    assert_equal [nil], calculator(@reader, @writer)
  end

  def test_calculate
    assert_equal 2, calculate('1', '1', :+)
    assert_equal 0, calculate('1', '1', :-)
    assert_equal 1, calculate('1', '1', :*)
    assert_equal 1.0, calculate('1', '1', :/)
  end

  def test_new_calc
    @reader.responses = %w[1 1 1 y 1 1 1]
    assert_equal [2, 2], calculator(@reader, @writer)
  end

  def test_new_calc_often
    @reader.responses = %w[1 1 1 y 1 1 2 y 3 4 3 n]
    assert_equal [2, 0, 12], calculator(@reader, @writer)
  end

  def test_no_new_calc
    @reader.responses = %w[1 1 1 n]
    assert_equal [2], calculator(@reader, @writer)
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

    def read_new_calc
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

    def ask_for_new_calc; end

    def display_goodbye; end
  end
end
