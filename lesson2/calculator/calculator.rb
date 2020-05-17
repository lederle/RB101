# frozen_string_literal: true

require 'pry'
require_relative 'reader'
require_relative 'writer'

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

# calculator
