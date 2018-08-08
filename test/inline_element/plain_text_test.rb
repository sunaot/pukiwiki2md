require 'test_helper'

class PlainTextTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.plain_text.parse('plaintext')
    assert_tree({ :plain_text => 'plaintext' }, result)
  end

  def test_transform
    result = @parser.plain_text.parse('plaintext')
    assert_equal 'plaintext', @trans.apply(result)
  end
end
