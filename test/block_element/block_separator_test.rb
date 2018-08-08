require 'test_helper'

class BlockSeparatorTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.block_separator.parse("\n")
    assert_tree({:block_separator => "\n"}, result)
  end

  def test_transform
    result = @parser.block_separator.parse("\n")
    assert_equal "\n", @trans.apply(result)
  end
end
