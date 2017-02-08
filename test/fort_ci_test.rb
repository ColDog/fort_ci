require 'test_helper'

class FortCITest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FortCI::VERSION
  end

  def test_it_does_something_useful
    FortCI
  end
end
