require 'test_helper'

class QuoteTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.quote.parse(sample_quote_text)
    assert_tree({:quote_lines => [
      { :line => t('Hello, World') },
      { :line => t('Second Line') }
    ]}, result)
  end

  def test_transform
    result = @parser.quote.parse(sample_quote_text)
    assert_equal <<-TEXT, @trans.apply(result)
> Hello, World
> Second Line
    TEXT
  end

  def sample_quote_text
    <<~TEXT
    > Hello, World
    > Second Line
    TEXT
  end
end
