require 'test_helper'

class OrderedListTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.ordered_list.parse(sample_ordered_list)
    assert_tree({:ordered_list => [
                  {:plus => '+', :item => t('First line')},
                  {:plus => '+', :item => t('Second line')},
                  {:plus => '++', :item => t('child 1st')},
                  {:plus => '++', :item => t('child 2nd')},
                  {:plus => '+++', :item => t('child child')} ]}, result)
  end

  def test_transform
    result = @parser.ordered_list.parse(sample_ordered_list)
    assert_equal <<-TEXT, @trans.apply(result)
1. First line
1. Second line
    1. child 1st
    1. child 2nd
        1. child child
    TEXT
  end

  def sample_ordered_list
    <<-TEXT
+ First line
+ Second line
++ child 1st
++ child 2nd
+++ child child
    TEXT
  end
end
