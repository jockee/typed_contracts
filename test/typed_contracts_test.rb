require "test_helper"

class TypedContractsTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TypedContracts::VERSION
  end

  def test_maybeof_exists
    assert TypedContracts::MaybeOf
  end

  def test_maybe_string_is_valid
    assert TypedContracts::MaybeOf[String].valid?(Maybe("a"))
  end

  def test_string_isnt_valid
    refute TypedContracts::MaybeOf[String].valid?("a")
  end
end
