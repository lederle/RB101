require 'minitest/autorun'
require_relative 'writer'

# Test the Writer; use a StringIO
# to fake $stdout. Much of the goings-on
# here seem useless, or simply testing
# the IO functionality, but if you testing
# first, theses tests form a "are the messages
# as wanted" spec of sorts.
class GermanWriterTest < Minitest::Test
  def setup
    @stream = StringIO.new
    @writer = Writer
    @writer.change_lang('de')
  end

  def test_german
    @writer.change_lang('de')
    @writer.ruby @stream
    @stream.rewind
    assert_equal "=> Rubin\n", @stream.read
  end

  def test_de_display_banner
    @writer.display_banner @stream
    @stream.rewind
    expected = <<~OUT
      => Willkommen im Taschenrechner! Gib deinen Namen ein:
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_ask_for_first_number
    @writer.ask_for_number @stream, :first
    @stream.rewind
    expected = <<~OUT
      => Was ist die erste Nummer?
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_ask_for_second_number
    @writer.ask_for_number @stream, :second
    @stream.rewind
    expected = <<~OUT
      => Was ist die zweite Nummer?
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_ask_for_operation
    @writer.ask_for_operation @stream
    @stream.rewind
    expected = <<~OUT
      => Welche arithmetische Operation möchten Sie ausführen?
         1) hinzufügen
         2) subtrahieren
         3) multiplizieren
         4) teilen
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_result
    res = 22
    out = @writer.display_result @stream, res
    @stream.rewind
    expected = <<~OUT
      => Das Ergebnis ist 22
    OUT
    assert_equal expected, @stream.read
    assert_equal 22, out
  end

  def test_de_display_message_for_invalid_number
    @writer.display_invalid_number @stream
    @stream.rewind
    expected = <<~OUT
      => Hm... das sieht nicht nach einer gültigen Nummer aus
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_ask_for_another_calculation
    @writer.ask_for_new_calc @stream
    @stream.rewind
    expected = <<~OUT
      => Möchten Sie eine weitere Berechnung durchführen? (Y, um erneut zu berechnen)
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_goodbye
    @writer.display_goodbye @stream
    @stream.rewind
    expected = <<~OUT
      => Vielen Dank, dass Sie den Taschenrechner verwenden. Auf Wiedersehen!
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_message_for_invalid_name
    @writer.display_name_error @stream
    @stream.rewind
    expected = <<~OUT
      => Sei nett, gib deinen Namen ein
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_greeting
    name = 'josef'
    @writer.display_greeting @stream, name
    @stream.rewind
    expected = <<~OUT
      => Hallo, josef
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_message_for_invalid_operator
    @writer.display_operator_error @stream
    @stream.rewind
    expected = <<~OUT
      => Muss 1, 2, 3 oder 4 wählen
    OUT
    assert_equal expected, @stream.read
  end

  def test_de_display_operation_gerund_form
    oper = '1'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    # les or des?
    expected = <<~OUT
      => Hinzufügen der beiden Zahlen...
    OUT
    assert_equal expected, @stream.read

    # reset stream
    @stream.truncate(0)
    @stream.rewind

    oper = '2'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Subtrahieren der beiden Zahlen...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '3'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    # check trans., prob wrong
    expected = <<~OUT
      => Multiplizieren der beiden Zahlen...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '4'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    # check trans., prob wrong
    expected = <<~OUT
      => Teilen der beiden Zahlen...
    OUT
    assert_equal expected, @stream.read
  end
end
