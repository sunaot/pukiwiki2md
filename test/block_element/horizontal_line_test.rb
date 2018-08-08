require 'test_helper'

class HorizontalLineTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.horizontal_line.parse("----\n")
    assert_tree({:horizontal_line => '----'}, result)
  end

  def test_transform
    result = @parser.horizontal_line.parse("----\n")
    assert_equal "---\n", @trans.apply(result)
  end
end
