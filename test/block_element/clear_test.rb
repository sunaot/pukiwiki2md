require 'test_helper'

class ClearTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.clear.parse("#clear\n")
    assert_tree({:clear => '#clear'}, result)
  end

  def test_transform
    result = @parser.clear.parse("#clear\n")
    assert_equal <<-TEXT, @trans.apply(result)
<!---
    clear
--->
    TEXT
  end
end
