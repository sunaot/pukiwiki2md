require 'test_helper'

class TocTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.toc.parse("#contents\n")
    assert_tree({:toc => '#contents'}, result)
  end

  def test_toc_transform
    result = @parser.toc.parse("#contents\n")
    assert_equal <<-TEXT, @trans.apply(result)
<!---
    toc
--->
    TEXT
  end
end
