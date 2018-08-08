require 'test_helper'

class ItalicTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.italic.parse("'''italictext'''")
    assert_tree({:l => "'''", :italic => 'italictext', :r => "'''"}, result)
  end

  def test_tranform
    result = @parser.italic.parse("'''italictext'''")
    assert_equal ' _italictext_ ', @trans.apply(result)
  end
end
