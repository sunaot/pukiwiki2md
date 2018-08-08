require 'test_helper'

class TableTest < Minitest::Test
  include Pukiwiki2md::TestHelper

  def setup
    @parser = ::Pukiwiki2md::Parser.new
    @trans = ::Pukiwiki2md::Transform.new
  end

  def test_parse_with_header
    result = @parser.table.parse(sample_table_with_header)
    assert_tree(
      {:header => [ { :cell => 'head1' }, { :cell => 'head2' }, { :cell => 'head3' } ],
       :other_rows  => [
                         { :row => [ { :cell => 'r1c1' }, { :cell => 'r1c2' }, { :cell => 'r1c3' } ] },
                         { :row => [ { :cell => 'r2c1' }, { :cell => 'r2c2' }, { :cell => 'r2c3' } ] },
                         { :row => [ { :cell => 'r3c1' }, { :cell => 'r3c2' }, { :cell => 'r3c3' } ] }
                       ]
      }, result)
  end

  def test_parse_with_no_header
    result = @parser.table.parse(sample_table_with_no_header)
    assert_tree(
      {:top_row => [ { :cell => 'r1c1' }, { :cell => 'r1c2' }, { :cell => 'r1c3' } ],
       :other_rows  => [
                         { :row => [ { :cell => 'r2c1' }, { :cell => 'r2c2' }, { :cell => 'r2c3' } ] },
                         { :row => [ { :cell => 'r3c1' }, { :cell => 'r3c2' }, { :cell => 'r3c3' } ] }
                       ]
      }, result)
  end

  def test_transform_with_header
    result = @parser.table.parse(sample_table_with_header)
    assert_equal <<-TEXT, @trans.apply(result)
|head1|head2|head3|
| --- | --- | --- |
|r1c1|r1c2|r1c3|
|r2c1|r2c2|r2c3|
|r3c1|r3c2|r3c3|
    TEXT
  end

  def test_transform_with_no_header
    result = @parser.table.parse(sample_table_with_no_header)
    assert_equal <<-TEXT, @trans.apply(result)
| | | |
| --- | --- | --- |
|r1c1|r1c2|r1c3|
|r2c1|r2c2|r2c3|
|r3c1|r3c2|r3c3|
    TEXT
  end

  def sample_table_with_header
    <<-TEXT
|head1|head2|head3|h
|r1c1|r1c2|r1c3|
|r2c1|r2c2|r2c3|
|r3c1|r3c2|r3c3|
    TEXT
  end

  def sample_table_with_no_header
    <<-TEXT
|r1c1|r1c2|r1c3|
|r2c1|r2c2|r2c3|
|r3c1|r3c2|r3c3|
    TEXT
  end

  def test_parse_top_row_only
    result = @parser.table.parse(<<-TEXT)
|cell|
    TEXT
    assert_tree({ :top_row => [{ :cell => 'cell'}], :other_rows => nil }, result)
  end

  def test_transform_top_row_only
    result = @parser.table.parse(<<-TEXT)
|cell|
    TEXT
    assert_equal(<<-TEXT, @trans.apply(result))
| |
| --- |
|cell|
    TEXT
  end

  def test_parse_header_only
    result = @parser.table.parse(<<-TEXT)
|cell|h
    TEXT
    assert_tree({ :header => [{ :cell => 'cell'}], :other_rows => nil }, result)
  end

  def test_transform_header_only
    result = @parser.table.parse(<<-TEXT)
|cell|h
    TEXT
    assert_equal(<<-TEXT, @trans.apply(result))
|cell|
| --- |
    TEXT
  end

  def test_parse_empty_cell
    result = @parser.table.parse(<<-TEXT)
|cell||
    TEXT
    assert_tree({ :top_row => [{ :cell => 'cell'}, { :cell => '' }], :other_rows => nil }, result)
  end

  def test_transform_empty_cell
    result = @parser.table.parse(<<-TEXT)
|cell||
    TEXT
    assert_equal(<<-TEXT, @trans.apply(result))
| | |
| --- | --- |
|cell||
    TEXT
  end
end
