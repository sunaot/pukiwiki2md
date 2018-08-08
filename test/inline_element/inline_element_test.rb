require 'test_helper'

class InlineTextTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.inline_text.parse("aaa''strong''bbb%%deleted%%ccc")
    assert_tree({:inline_text => [
      { :plain_text => 'aaa' },
      { :strong => 'strong', :l => "''", :r => "''" },
      { :plain_text => 'bbb' },
      { :deleted => 'deleted', :l => '%%', :r => '%%' },
      { :plain_text => 'ccc' }
    ]}, result)
  end

  def test_parse_plain_text
    result = @parser.inline_text.parse('plaintext')
    assert_tree({:inline_text => [ { :plain_text => 'plaintext' } ]}, result)
  end

  def test_parse_attachment
    result = @parser.inline_text.parse('aaa&ref(file.zip);bbb')
    assert_tree({:inline_text => [
      { :plain_text => 'aaa' },
      { :file => 'file.zip', :l => '&ref(', :r => ');' },
      { :plain_text => 'bbb' }
    ]}, result)
  end

  def test_transform
    result = @parser.inline_text.parse("aaa''strong''bbb%%deleted%%ccc")
    assert_equal('aaa **strong** bbb ~~deleted~~ ccc', @trans.apply(result))
  end
end
