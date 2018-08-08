require 'test_helper'

class BlockMarginTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.block_margin.parse("#br\n")
    assert_tree({:block_margin => '#br'}, result)
  end

  def test_transform
    result = @parser.block_margin.parse("#br\n")
    assert_equal "<br />\n", @trans.apply(result)
  end
end
