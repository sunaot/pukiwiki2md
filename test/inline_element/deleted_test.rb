require 'test_helper'

class DeletedTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse
    result = @parser.deleted.parse('%%text%%')
    assert_tree({:l => '%%', :deleted => 'text', :r => '%%'}, result)
  end

  def test_tranform
    result = @parser.deleted.parse('%%text%%')
    assert_equal ' ~~text~~ ', @trans.apply(result)
  end
end
