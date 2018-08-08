require 'test_helper'

class BlockAttachmentTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse_image
    result = @parser.block_attachment.parse("#ref(foo.jpg)\n")
    assert_tree({:block_image => 'foo.jpg', :l => '#ref(', :r => ')'}, result)
  end

  def test_parse_file
    result = @parser.block_attachment.parse("#ref(foo.pdf)\n")
    assert_tree({:block_file => 'foo.pdf', :l => '#ref(', :r => ')'}, result)
  end

  def test_parse_image_url
    result = @parser.block_attachment.parse("#ref(http://example.com/foo.png)\n")
    assert_tree({:block_image_url => 'http://example.com/foo.png', :l => '#ref(', :r => ')'}, result)
  end

  def test_parse_file_url
    result = @parser.block_attachment.parse("#ref(https://example.com/foo.zip)\n")
    assert_tree({:block_file_url => 'https://example.com/foo.zip', :l => '#ref(', :r => ')'}, result)
  end

  def test_transform_image
    result = @parser.block_attachment.parse("#ref(foo.jpg)\n")
    assert_equal "![foo.jpg](foo.jpg)\n", @trans.apply(result)
  end

  def test_transform_filename
    result = @parser.block_attachment.parse("#ref(foo.pdf)\n")
    assert_equal "[foo.pdf](foo.pdf)\n", @trans.apply(result)
  end

  def test_transform_image_url
    result = @parser.block_attachment.parse("#ref(https://example.com/foo.png)\n")
    assert_equal "![foo.png](https://example.com/foo.png)\n", @trans.apply(result)
  end

  def test_transform_file_url
    result = @parser.block_attachment.parse("#ref(https://example.com/foo.zip)\n")
    assert_equal "[foo.zip](https://example.com/foo.zip)\n", @trans.apply(result)
  end
end
