require 'test_helper'

class SeparatorLineTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.separator_line.parse("#hr\n")
    assert_tree({:separator_line => '#hr'}, result)
  end

  def test_transform
    result = @parser.separator_line.parse("#hr\n")
    assert_equal "---\n", @trans.apply(result)
  end
end
