require 'minitest/autorun'
require_relative 'writer'

# Test the Writer; use a StringIO
# to fake $stdout. Much of the goings-on
# here seem useless, or simply testing
# the IO functionality, but if you testing
# first, these tests form a "are the messages
# as wanted" spec of sorts.
class KoreanWriterTest < Minitest::Test
  def setup
    @stream = StringIO.new
    @writer = Writer
    @writer.change_lang('ko')
  end

  def test_korean
    @writer.change_lang('ko')
    @writer.ruby @stream
    @stream.rewind
    assert_equal "=> 루비\n", @stream.read
  end

  def test_display_banner
    @writer.display_banner @stream
    @stream.rewind
    expected = <<~OUT
      => 계산기에 오신 것을 환영합니다! 당신의 이름을 입력:
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_first_number
    @writer.ask_for_number @stream, :first
    @stream.rewind
    expected = <<~OUT
      => 첫 번째 숫자는 무엇입니까?
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_second_number
    @writer.ask_for_number @stream, :second
    @stream.rewind
    expected = <<~OUT
      => 두 번째 숫자는 무엇입니까?
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_operation
    @writer.ask_for_operation @stream
    @stream.rewind
    expected = <<~OUT
      => 어떤 작업을 수행 하시겠습니까?
         1) 더하기
         2) 빼기
         3) 곱하기
         4) 나누다
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_result
    res = 22
    out = @writer.display_result @stream, res
    @stream.rewind
    expected = <<~OUT
      => 결과는 22
    OUT
    assert_equal expected, @stream.read
    assert_equal 22, out
  end

  def test_display_message_for_invalid_number
    @writer.display_invalid_number @stream
    @stream.rewind
    expected = <<~OUT
      => 음 ... 유효한 숫자가 아닌 것 같습니다
    OUT
    assert_equal expected, @stream.read
  end

  def test_ask_for_another_calculation
    @writer.ask_for_new_calc @stream
    @stream.rewind
    expected = <<~OUT
      => 다른 계산을 수행 하시겠습니까 (예 : 다시 계산)
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_goodbye
    @writer.display_goodbye @stream
    @stream.rewind
    expected = <<~OUT
      => 계산기를 이용해 주셔서 감사합니다. 안녕!
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_message_for_invalid_name
    @writer.display_name_error @stream
    @stream.rewind
    expected = <<~OUT
      => 좋아, 이름을 입력 해
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_greeting
    skip
    name = '병철'
    @writer.display_greeting @stream, name
    @stream.rewind
    expected = <<~OUT
      => 안녕 병철
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_message_for_invalid_operator
    @writer.display_operator_error @stream
    @stream.rewind
    expected = <<~OUT
      => 1, 2, 3 또는 4를 선택해야합니다
    OUT
    assert_equal expected, @stream.read
  end

  def test_display_operation_gerund_form
    oper = '1'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => 두 숫자를 더함...
    OUT
    assert_equal expected, @stream.read
    # reset stream
    @stream.truncate(0)
    @stream.rewind

    oper = '2'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => 두 숫자를 빼기...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '3'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => 두 숫자를 곱하면...
    OUT
    assert_equal expected, @stream.read

    @stream.truncate(0)
    @stream.rewind

    oper = '4'
    @writer.display_operator_gerund_form(@stream, oper)
    @stream.rewind
    expected = <<~OUT
      => 두 숫자를 나누다...
    OUT
    assert_equal expected, @stream.read
  end
end
