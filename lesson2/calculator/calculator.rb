# frozen_string_literal: true

require 'pry'
require_relative 'reader'
require_relative 'writer'

# do arithmetic on two numbers, over and over
# if you want

LANG = 'en'
def calculator(reader = Reader, writer = Writer)
  ret = []
  writer.display_banner
  until (name = reader.read_name)
    writer.display_name_error
  end
  writer.display_greeting name
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
    until (operation = reader.read_op)
      writer.display_operator_error
    end
    # binding.pry
    writer.display_operator_gerund_form(operation)
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
  # check if float rep mod 1 is zero to determine if int.
  # Use lambda to keep convert method private to calculate.
  convert = lambda do |num|
    # check_if_int
    (num.to_f % 1).zero? ? num.to_i : num.to_f
  end

  num1 = convert.call(num1)
  num2 = convert.call(num2)
  num1 = oper.to_s == '/' ? num1.to_f : num1
  num1.send(oper, num2)
end

# calculator
