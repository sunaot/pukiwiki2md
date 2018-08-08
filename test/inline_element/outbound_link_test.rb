require 'test_helper'

class OutboundLinkTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.outbound_link.parse('[[blog:http://example.com/blog]]')
    assert_tree({ :link_text => 'blog', :link_url => 'http://example.com/blog' }, result)
  end

  def test_parse_greater_than_style
    result = @parser.outbound_link.parse('[[blog>http://example.com/blog]]')
    assert_tree({ :link_text => 'blog', :link_url => 'http://example.com/blog' }, result)
  end

  def test_parse_last_colon
    result = @parser.outbound_link.parse('[[blog:This is::Blog:http://example.com/blog]]')
    assert_tree({ :link_text => 'blog:This is::Blog', :link_url => 'http://example.com/blog' }, result)
  end

  def test_transform
    result = @parser.outbound_link.parse('[[blog:http://example.com/blog]]')
    assert_equal '[blog](http://example.com/blog)', @trans.apply(result)
  end
end
