require 'test_helper'

class TestHelperTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def test_recursive_transform_values
    assert_equal({:foo => 'bar'}, recursive_transform_values({:foo => :bar}))
    assert_equal({:a => 'b', :c => 'd'}, recursive_transform_values({:a => :b, :c => :d}))
    assert_equal({:foo => [{:a => 'b'}, {:c => 'd'}], :bar => 'baz'},
                 recursive_transform_values({:foo => [{:a => :b}, {:c => :d}], :bar => :baz}))
    assert_equal({:foo => {:bar => 'baz'}}, recursive_transform_values({:foo => {:bar => :baz}}))
    assert_equal('abc', ::Parslet::Slice.new(0, 'abc'))
  end
end
