# Writer is a helper class for the calculator
# function. The default parameter is $stdout
# but its main reason to be is to allow a
# fake writer to by substituted during testing.
# It performs the puts-related operations
# for calculator.

require 'yaml'

class Writer
  MESSAGES = YAML.load_file('message_config.yml')

  def self.display_banner(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['welcome'])
  end

  def self.ask_for_number(o_stream = $stdout, term)
    o_stream.puts decorate(format(MESSAGES['get_number'], term: term.to_s))
  end

  def self.ask_for_operation(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['get_operation'])
  end

  def self.display_result(o_stream = $stdout, res)
    o_stream.puts decorate(format(MESSAGES['result'], res: res))
    res
  end

  def self.display_invalid_number(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['number_error'])
  end

  def self.ask_for_new_calc(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['get_new_calc'])
  end

  def self.display_goodbye(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['goodbye'])
  end

  def self.display_name_error(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['name_error'])
  end

  def self.display_greeting(o_stream = $stdout, name)
    o_stream.puts decorate(format(MESSAGES['say_name'], name: name))
  end

  def self.display_operator_error(o_stream = $stdout)
    o_stream.puts decorate(MESSAGES['operator_error'])
  end

  def self.display_operator_gerund_form(o_stream = $stdout, operator)
    o_stream.puts decorate(format(MESSAGES['say_operator'],
                                  gerund: operation_to_message(operator)))
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

  def operation_to_message(operator)
    case operator
    when '1'
      'Adding'
    when '2'
      'Subtracting'
    when '3'
      'Multiplying'
    when '4'
      'Dividing'
    end
  end
end
