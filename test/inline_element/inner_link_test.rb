require 'test_helper'

class InnerLinkTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.inner_link.parse("[[WikiName]]")
    assert_tree({:l => "[[", :inner_link => 'WikiName', :r => "]]"}, result)
  end

  def test_tranform
    result = @parser.inner_link.parse("[[WikiName]]")
    assert_equal('[WikiName]', @trans.apply(result))
  end
end
