require 'minitest/autorun'
require_relative 'writer'

# Test the Writer; use a StringIO
# to fake $stdout. Much of the goings-on
# here seem useless, or simply testing
# the IO functionality, but if you testing
# first, theses tests form a "are the messages
# as wanted" spec of sorts.
class FrenchWriterTest < Minitest::Test
  def setup
    @stream = StringIO.new
    @writer = Writer
    @writer.change_lang('fr')
  end

  def test_french
    @writer.change_lang('fr')
    @writer.ruby @stream
    @stream.rewind
    assert_equal "=> rubis\n", @stream.read
  end

  def test_fr_display_banner
    @writer.display_banner @stream
    @stream.rewind
    expected = <<~OUT
      => Bienvenue dans la calculatrice! Entrez votre nom:
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_ask_for_first_number
    @writer.ask_for_number @stream, :first
    @stream.rewind
    expected = <<~OUT
      => Quel est le premier numéro?
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_ask_for_second_number
    @writer.ask_for_number @stream, :second
    @stream.rewind
    expected = <<~OUT
      => Quel est le deuxième numéro?
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_ask_for_operation
    @writer.ask_for_operation @stream
    @stream.rewind
    expected = <<~OUT
      => Quelle opération arithmétique aimeriez-vous effectuer?
         1) ajouter
         2) soustraire
         3) multiplier
         4) divisier
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_result
    res = 22
    out = @writer.display_result @stream, res
    @stream.rewind
    expected = <<~OUT
      => Le résultat est 22
    OUT
    assert_equal expected, @stream.read
    assert_equal 22, out
  end

  def test_fr_display_message_for_invalid_number
    @writer.display_invalid_number @stream
    @stream.rewind
    expected = <<~OUT
      => Hum... cela ne ressemble pas à un numéro valide
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_ask_for_another_calculation
    @writer.ask_for_new_calc @stream
    @stream.rewind
    expected = <<~OUT
      => Voulez-vous effectuer un autre calcul? (Y pour recalculer)
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_goodbye
    @writer.display_goodbye @stream
    @stream.rewind
    expected = <<~OUT
      => Merci d'utiliser la calculatrice. Au revoir!
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_message_for_invalid_name
    @writer.display_name_error @stream
    @stream.rewind
    expected = <<~OUT
      => Soyez gentil, entrez votre nom
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_greeting
    name = 'jojo'
    @writer.display_greeting @stream, name
    @stream.rewind
    expected = <<~OUT
      => Salut, jojo
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_message_for_invalid_operator
    @writer.display_operator_error @stream
    @stream.rewind
    expected = <<~OUT
      => Doit choisir 1, 2, 3 ou 4
    OUT
    assert_equal expected, @stream.read
  end

  def test_fr_display_operation_gerund_form
    oper = '1'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    # les or des?
    expected = <<~OUT
      => Ajout les deux nombres...
    OUT
    assert_equal expected, @stream.read

    # reset stream
    @stream.truncate(0)
    @stream.rewind

    oper = '2'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Soustraire les deux nombres...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '3'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Multiplier les deux nombres...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '4'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => Diviser les deux nombres...
    OUT
    assert_equal expected, @stream.read
  end
end
