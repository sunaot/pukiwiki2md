$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pukiwiki2md'
require 'minitest/autorun'
require 'parslet/convenience'

module Pukiwiki2md
  module TestHelper
    EOL = "\n"

    private
    def assert_tree(expected, actual, message = nil)
      assert_equal expected, recursive_transform_values(actual), message
    end

    def inline_text(text)
      { :inline_text => [ { :plain_text => text } ] }
    end
    alias_method :t, :inline_text

    # Recursize version of Hash#transform_values
    def recursive_transform_values(parsed)
      case parsed
      when Hash
        node_pairs = parsed.flatten
        node_pairs.each_slice(2).reduce({}) do |result, (key,val)|
          case val
          when Array
            result.merge({ key => val.map {|v| recursive_transform_values(v) } })
          when Hash
            result.merge({ key => recursive_transform_values(val) })
          when ::Parslet::Slice, String, Symbol
            result.merge({ key => val.to_s })
          when nil
            result.merge({ key => val })
          else
            raise "Error: Unknown type #{val.inspect}"
          end
        end
      when Array
        parsed.map do |node|
          recursive_transform_values(node)
        end
      when ::Parslet::Slice
        parsed.to_s
      when nil
        nil
      else
        raise "Error: in recursive_transform_values\n-> (#{parsed.inspect})"
      end
    end
  end
end

BEGIN {
  require 'simplecov'
  SimpleCov.start
}
