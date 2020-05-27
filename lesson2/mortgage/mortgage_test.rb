require 'minitest/autorun'
require_relative 'mock_reader'
require_relative 'mock_writer'
require_relative 'mortgage'

class MortgageTest < Minitest::Test
  def setup
    @reader = MockReader.new
    @writer = MockWriter.new
  end

  def add_newline(arr)
    arr.map { |e| e << "\n" }
  end

  def test_happy
    # principle, annual interest, term in years
    @reader.responses = add_newline(%w[1000 0.05 1 n])
    assert_in_delta 50, mortgage(@reader, @writer).pop
  end
end
