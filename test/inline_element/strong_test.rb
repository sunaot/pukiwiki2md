require 'test_helper'

class StrongTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.strong.parse("''strongtext''")
    assert_tree({:l => "''", :strong => 'strongtext', :r => "''"}, result)
  end

  def test_tranform
    result = @parser.strong.parse("''strongtext''")
    assert_equal(' **strongtext** ', @trans.apply(result))
  end
end
