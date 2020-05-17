require 'minitest/autorun'
require_relative 'reader'

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

  def test_read_number_given_a_number
    assert_equal '10', read_num("10\n")
  end

  def test_read_number_given_not_a_number
    refute read_num("k\n")
  end

  def test_read_number_given_newline
    refute read_num("\n")
  end

  def test_read_number_check_not_nil
    refute_nil read_num("k\n")
  end

  def test_read_number_given_zero
    refute read_num("0\n")
  end

  def test_read_op_given_valid_op
    assert_equal '1', read_op("1\n")
  end

  def test_read_op_given_invalid_op
    assert_equal '11', read_op("11\n")
  end

  def test_read_new_calc_given_yes
    assert_equal 'y', read_new_calc("y\n")
  end

  def test_read_new_calc_given_capital_y
    assert_equal 'y', read_new_calc("Y\n")
  end

  def test_read_new_calc_given_not_yes
    assert_equal 'n', read_new_calc("n\n")
  end

  def test_read_new_calc_given_newline
    assert_equal '', read_new_calc("\n")
  end
end

