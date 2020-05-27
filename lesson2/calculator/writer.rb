# Writer is a helper class for the calculator
# function. The default parameter is $stdout
# but its main reason to be is to allow a
# fake writer to by substituted during testing.
# It performs the puts-related operations
# for calculator.

require 'yaml'
require 'pry'

class Writer
  MESSAGES = YAML.load_file('message_config.yml')

  # use class instance variable
  @lang = 'ko'
  class << self # all self methods could be in here
    attr_accessor :lang
  end

  def self.change_lang(a_lang)
    @lang = a_lang
  end

  def self.ruby(o_stream = $stdout)
    write_to_stream(o_stream, messages('test'))
  end

  def self.display_banner(o_stream = $stdout)
    write_to_stream(o_stream, messages('welcome'))
  end

  def self.ask_for_number(o_stream = $stdout, term)
    write_to_stream(o_stream,
                    messages('get_number', term: ordinal(term)))
  end

  def self.ask_for_operation(o_stream = $stdout)
    write_to_stream(o_stream, messages('get_operation'))
  end

  def self.display_result(o_stream = $stdout, res)
    write_to_stream(o_stream,
                    messages('result', res: res))
    res
  end

  def self.display_invalid_number(o_stream = $stdout)
    write_to_stream(o_stream, messages('number_error'))
  end

  def self.ask_for_new_calc(o_stream = $stdout)
    write_to_stream(o_stream, messages('get_new_calc'))
  end

  def self.display_goodbye(o_stream = $stdout)
    write_to_stream(o_stream, messages('goodbye'))
  end

  def self.display_name_error(o_stream = $stdout)
    write_to_stream(o_stream, messages('name_error'))
  end

  def self.display_greeting(o_stream = $stdout, name)
    write_to_stream(o_stream, messages('say_name', name: name))
  end

  def self.display_operator_error(o_stream = $stdout)
    write_to_stream(o_stream, messages('operator_error'))
  end

  def self.display_operator_gerund_form(o_stream = $stdout, operator)
    write_to_stream(o_stream,
                    messages('say_operator',
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
      Writer::MESSAGES[lang]['adding']
    when '2'
      Writer::MESSAGES[lang]['subtracting']
    when '3'
      Writer::MESSAGES[lang]['multiplying']
    when '4'
      Writer::MESSAGES[lang]['dividing']
    end
  end

  def ordinal(term)
    Writer::MESSAGES[lang][term.to_s]
  end

  def write_to_stream(stream, streamlet)
    stream.puts streamlet
  end

  def messages(key, interpolators = nil)
    return decorate(Writer::MESSAGES[lang][key]) unless interpolators

    decorate(format(Writer::MESSAGES[lang][key], interpolators))
  end
end
