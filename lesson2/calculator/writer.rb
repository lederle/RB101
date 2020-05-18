# Writer is a helper class for the calculator
# function. The default parameter is $stdout
# but its main reason to be is to allow a
# fake writer to by substituted during testing.
# It performs the puts-related operations
# for calculator.
class Writer
  def self.display_banner(o_stream = $stdout)
    o_stream.puts decorate('Welcome to Calculator! Enter your name:')
  end

  def self.ask_for_number(o_stream = $stdout, term)
    # Note to self: symbol auto converts to string
    o_stream.puts decorate("What's the #{term} number?")
  end

  def self.ask_for_operation(o_stream = $stdout)
    o_stream.puts decorate('What operation would you like to perform? 1) add 2) subtract 3) multiply 4) divide')
  end

  def self.display_result(o_stream = $stdout, res)
    o_stream.puts decorate("The result is #{res}")
    res
  end

  def self.display_invalid_number(o_stream = $stdout)
    o_stream.puts decorate("Hmm... that doesn't look like a valid number")
  end

  def self.ask_for_new_calc(o_stream = $stdout)
    o_stream.puts decorate('Do you want to perform another calculation? (Y to calculate again)')
  end

  def self.display_goodbye(o_stream = $stdout)
    o_stream.puts decorate('Thank you for using the calculator. Good bye!')
  end

  def self.display_name_error(o_stream = $stdout)
    o_stream.puts decorate('Be nice, enter your name')
  end

  def self.display_greeting(o_stream = $stdout, name)
    o_stream.puts decorate("Hi, #{name}")
  end
end

# This is a semi-hack for now, it creates a private
# class method. My intent was to add decorate
# as a private instance method and just use
# it within Writer, but I get NoMethodError
# when used this way, I'm not understanding
# something about class methods and I can't
# ferret out an SO post that covers this
# particular situation. The hack does provide the
# desired intent, no one can use decorate except
# Writer members. Why? I didn't like the idea of
# calculator using decorate, it feels more
# appropriate in the domain of Writer.
class << Writer
  private

  def decorate(message)
    '=> ' + message
  end
end
