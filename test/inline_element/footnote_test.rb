require 'test_helper'

class FootnoteTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.footnote.parse('((footnote))')
    assert_tree({:l => '((', :footnote => 'footnote', :r => '))'}, result)
  end
  
  def test_tranform
    result = @parser.footnote.parse('((footnote))')
    assert_equal '(footnote)', @trans.apply(result)
  end
end
