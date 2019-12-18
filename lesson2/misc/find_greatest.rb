# frozen_string_literal: true

def find_greatest(numbers)
  saved_number = nil

  numbers.each do |num|
    saved_number ||= num
    next if saved_number >= num

    saved_number = num
  end
  saved_number
end

p find_greatest([3, 6, 7, 45, 3, 4, 7])
