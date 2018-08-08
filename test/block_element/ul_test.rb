require 'test_helper'

class UnorderedListTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  # Known Issue:
  #   Inverted list is valid in PukiWiki but invalid in Markdown.
  #   Pukiwiki2md transforms this as it be and it could break rendering text in Markdown.
  #
  # --- 1st
  # - 2nd
  # -- 3rd
  #
  def test_parse
    result = @parser.unordered_list.parse(sample_unordered_list)
    assert_tree({:unordered_list => [
                  {:minus => '-', :item => t('First line')},
                  {:minus => '-', :item => t('Second line')},
                  {:minus => '--', :item => t('child 1st')},
                  {:minus => '--', :item => t('child 2nd')},
                  {:minus => '---', :item => t('child child')} ]}, result)
  end

  def test_ransform
    result = @parser.unordered_list.parse(sample_unordered_list)
    assert_equal <<-TEXT, @trans.apply(result)
* First line
* Second line
    * child 1st
    * child 2nd
        * child child
    TEXT
  end

  def sample_unordered_list
    <<-TEXT
- First line
- Second line
-- child 1st
-- child 2nd
--- child child
    TEXT
  end
end
