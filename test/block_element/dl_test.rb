require 'test_helper'

class DefinitionListTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  # Do not care about ':' repeat notation. Markdown has no definition list notation.
  def test_parse
    result = @parser.definition_list.parse(sample_definition_list)
    assert_tree({:definition_list => [
                  {:colon => ':', :term => '1st', :description => 'desc'},
                  {:colon => ':', :term => '2nd', :description => 'desc'},
                  {:colon => '::', :term => 'child', :description => 'desc'},
                  {:colon => ':::', :term => 'child child', :description => 'desc'}
    ]}, result)
  end

  def test_transform
    result = @parser.definition_list.parse(sample_definition_list)
    assert_equal <<-TEXT, @trans.apply(result)
<dl>
    <dt>1st</dt>
    <dd>desc</dd>
    <dt>2nd</dt>
    <dd>desc</dd>
    <dt>child</dt>
    <dd>desc</dd>
    <dt>child child</dt>
    <dd>desc</dd>
</dl>
    TEXT
  end

  def sample_definition_list
    <<-TEXT
:1st|desc
:2nd|desc
::child|desc
:::child child|desc
    TEXT
  end
end
