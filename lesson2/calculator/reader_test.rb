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

