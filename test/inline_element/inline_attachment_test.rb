require 'test_helper'

class InlineAttachmentTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse_image
    result = @parser.inline_attachment.parse("&ref(foo.jpg);")
    assert_tree({:image => 'foo.jpg', :l => '&ref(', :r => ');'}, result)
  end

  def test_parse_file
    result = @parser.inline_attachment.parse("&ref(foo.pdf);")
    assert_tree({:file => 'foo.pdf', :l => '&ref(', :r => ');'}, result)
  end

  def test_parse_image_url
    result = @parser.inline_attachment.parse("&ref(http://example.com/foo.png);")
    assert_tree({:image_url => 'http://example.com/foo.png', :l => '&ref(', :r => ');'}, result)
  end

  def test_parse_file_url
    result = @parser.inline_attachment.parse("&ref(https://example.com/foo.zip);")
    assert_tree({:file_url => 'https://example.com/foo.zip', :l => '&ref(', :r => ');'}, result)
  end

  def test_transform_image
    result = @parser.inline_attachment.parse("&ref(foo.jpg);")
    assert_equal '![foo.jpg](foo.jpg)', @trans.apply(result)
  end

  def test_transform_filename
    result = @parser.inline_attachment.parse("&ref(foo.pdf);")
    assert_equal '[foo.pdf](foo.pdf)', @trans.apply(result)
  end

  def test_transform_image_url
    result = @parser.inline_attachment.parse("&ref(https://example.com/foo.png);")
    assert_equal '![foo.png](https://example.com/foo.png)', @trans.apply(result)
  end

  def test_transform_file_url
    result = @parser.inline_attachment.parse("&ref(https://example.com/foo.zip);")
    assert_equal '[foo.zip](https://example.com/foo.zip)', @trans.apply(result)
  end
end
