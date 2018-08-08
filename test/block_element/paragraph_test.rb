require 'test_helper'

class ParagraphTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.paragraph.parse(sample_paragraph)
    assert_tree({:paragraph_lines => [
      {:line => t('aaaaaaa') },
      {:line => t('bbbbbbb') },
      {:line => t('ccccccc') }
    ]}, result)
  end

  def test_transform
    result = @parser.paragraph.parse(sample_paragraph)
    assert_equal <<-TEXT, @trans.apply(result)
aaaaaaa
bbbbbbb
ccccccc
    TEXT
  end

  def sample_paragraph
    <<-TEXT
aaaaaaa
bbbbbbb
ccccccc
    TEXT
  end
end
