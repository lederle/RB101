# Reader is a helper class for the calculator
# function. The default parameter is $stdin
# but its main reason to be is to allow a
# fake reader to by substituted during testing.
# It performs the gets operations for the
# calculator.
class Reader
  def self.read_num(i_stream = $stdin)
    input = i_stream.gets.chomp
    valid?(input) && input
  end

  def self.read_op(i_stream = $stdin)
    i_stream.gets.chomp
  end

  def self.read_new_calc(i_stream = $stdin)
    i_stream.gets.chomp.downcase
  end
end

class << Reader
  private

  def valid?(num)
    num.to_i != 0
  end
end
