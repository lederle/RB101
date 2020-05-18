require 'minitest/autorun'

class CalculatorTest < Minitest::Test
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

    def display_name_error; end

    def display_greeting(name); end
  end
end
