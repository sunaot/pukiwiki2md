require 'test_helper'

class HeaderTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_h1_parse
    result = @parser.header.parse(sample_h1_header)
    assert_tree({:star => '*', :header => t('Hello, World')}, result)
  end

  def test_h1_transform
    result = @parser.header.parse(sample_h1_header)
    assert_equal "# Hello, World\n", @trans.apply(result)
  end

  def sample_h1_header
    '* Hello, World' + EOL
  end

  def test_h2_parse
    result = @parser.header.parse(sample_h2_header)
    assert_tree({:star => '**', :header => t('Hello, World')}, result)
  end

  def test_h2_transform
    result = @parser.header.parse(sample_h2_header)
    assert_equal "## Hello, World\n", @trans.apply(result)
  end

  def sample_h2_header
    '** Hello, World' + EOL
  end

  def test_h3_parse
    result = @parser.header.parse(sample_h3_header)
    assert_tree({:star => '***', :header => t('Hello, World')}, result)
  end

  def test_h3_transform
    result = @parser.header.parse(sample_h3_header)
    assert_equal "### Hello, World\n", @trans.apply(result)
  end

  def sample_h3_header
    '*** Hello, World' + EOL
  end

  def test_h1_parse_with_fragment
    result = @parser.header.parse('* Hello, World [#e652f146]'+EOL)
    assert_tree({ :star => '*',
                  :header => { :inline_text => [
                                 { :plain_text => 'Hello, World '},
                                 { :fragment => '[#e652f146]' } ]
                             }
                }, result)
  end

  def test_h1_transform_with_fragment
    result = @parser.header.parse('* Hello, World [#e652f146]'+EOL)
    assert_equal "# Hello, World \n", @trans.apply(result)
  end

  def test_h1_parse_with_empty_header_text
    result = @parser.header.parse('*'+EOL)
    assert_tree({:star => '*', :header => nil}, result)
  end

  def test_h1_transform_with_empty_header_text
    result = @parser.header.parse('*'+EOL)
    assert_equal "# \n", @trans.apply(result)
  end

  def test_parse_header_next_to_paragraph
    result = @parser.page_text.parse(<<-TEXT)
This is a paragraph.
Second line.
* Header [#01234567]
Another paragraph.
    TEXT
    assert_tree({
      :page_components => [
        { :paragraph_lines => [
            { :line => t('This is a paragraph.') },
            { :line => t('Second line.') }
        ]},
        { :star => '*', :header =>
            { :inline_text => [
                { :plain_text => 'Header ' },
                { :fragment => '[#01234567]'} ]
            }},
        { :paragraph_lines => [
            { :line => t('Another paragraph.') }
        ]},
      ]} , result)
  end

  def test_transform_header_next_to_paragraph
    result = @parser.page_text.parse(<<-TEXT)
This is a paragraph.
Second line.
* Header [#01234567]
Another paragraph.
    TEXT
    assert_equal <<-TEXT, @trans.apply(result)
This is a paragraph.
Second line.
# Header 
Another paragraph.
TEXT
  end
end
