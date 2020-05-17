require 'minitest/autorun'

class CalculatorTest < Minitest::Test
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
end
