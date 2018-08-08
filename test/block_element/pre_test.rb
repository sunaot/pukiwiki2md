require 'test_helper'

class PreformattedLineTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.preformatted.parse(sample_pre_text)
    assert_tree({:preformatted_lines => [
      { :line => 'Hello, World' },
      { :line => 'Second Line' }
    ]}, result)
  end

  def test_transform
    result = @parser.preformatted.parse(sample_pre_text)
    assert_equal <<-TEXT, @trans.apply(result)
```
Hello, World
Second Line
```
    TEXT
  end

  def sample_pre_text
    <<-TEXT
 Hello, World
 Second Line
    TEXT
  end

  def test_parse_with_break_only_line
    result = @parser.preformatted.parse(sample_pre_text_with_break_only_line)
    assert_tree({:preformatted_lines => [
      { :line => 'Hello, World' },
      { :line => nil },
      { :line => nil },
      { :line => 'Second Line' }
    ]}, result)
  end

  def test_transform_with_break_only_line
    result = @parser.preformatted.parse(sample_pre_text_with_break_only_line)
    assert_equal <<-TEXT, @trans.apply(result)
```
Hello, World


Second Line
```
    TEXT
  end

  def sample_pre_text_with_break_only_line
    <<-TEXT
 Hello, World
 
 
 Second Line
    TEXT
  end

  def test_parse_pre_next_to_paragraph
    result = @parser.page_text.parse(sample_pre_text_next_to_paragraph)
    assert_tree({
      :page_components => [
        { :paragraph_lines => [
            { :line => t('This is paragraph.') } ]},
        { :preformatted_lines => [
            { :line => %q(And it's preformatted text.) },
            { :line => %q(This is also preformatted.) } ]},
        { :paragraph_lines => [
            { :line => t('Then here comes another paragraph.') } ]}
      ]
    }, result)
  end

  def test_transform_pre_next_to_paragraph
    result = @parser.page_text.parse(sample_pre_text_next_to_paragraph)
    assert_equal <<-TEXT, @trans.apply(result)
This is paragraph.
```
And it's preformatted text.
This is also preformatted.
```
Then here comes another paragraph.
    TEXT
  end

  def sample_pre_text_next_to_paragraph
    <<-TEXT
This is paragraph.
 And it's preformatted text.
 This is also preformatted.
Then here comes another paragraph.
    TEXT
  end
end
