require 'minitest/autorun'
require_relative 'calculator'
require_relative 'mock_reader'
require_relative 'mock_writer'

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
end
