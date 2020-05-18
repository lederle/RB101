require 'minitest/autorun'
require_relative 'writer'

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
      => What operation would you like to perform?
         1) add
         2) subtract
         3) multiply
         4) divide
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

  def test_display_message_for_invalid_number
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

  def test_display_message_for_invalid_name
    @writer.display_name_error @stream
    @stream.rewind
    expected = <<~OUT
      => Be nice, enter your name
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_greeting
    name = 'joe'
    @writer.display_greeting @stream, name
    @stream.rewind
    expected = <<~OUT
      => Hi, joe
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_message_for_invalid_operator
    @writer.display_operator_error @stream
    @stream.rewind
    expected = <<~OUT
      => Must choose 1, 2, 3 or 4
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_operation_gerund_form
    oper = '1'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Adding the two numbers...
    OUT
    assert_equal expected, @stream.read

    #reset stream
    @stream.truncate(0)
    @stream.rewind

    oper = '2'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Subtracting the two numbers...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '3'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Multiplying the two numbers...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '4'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Dividing the two numbers...
    OUT
    assert_equal expected, @stream.read
  end
end
