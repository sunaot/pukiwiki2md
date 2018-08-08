require 'uri'
module Pukiwiki2md
  class AttachmentURL
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def basename
      File.basename(URI.parse(@url).path)
    end
  end

  class Transform < Parslet::Transform
    EOL = END_OF_LINE = "\n"
    INDENT = '    '

    rule(:line => simple(:s)) { s.to_s + EOL }

    rule(:page_components => sequence(:components)) { components.join }

    # header
    rule(:star => simple(:star), :header => simple(:s)) do
      [ '#' * star.length, ' ', s, EOL ].join
    end

    # fragment
    rule(:fragment => simple(:x)) do
      ''
    end

    # quote
    rule(:quote_lines => sequence(:lines)) { lines.map {|s| "> #{s}" }.join }

    # pre
    rule(:preformatted_lines => sequence(:lines)) {
      "```\n" + lines.join + "```\n"
    }

    # ul
    rule(:unordered_list => sequence(:lines)) { lines.join }
    rule(:minus => simple(:minus), :item => simple(:s)) do
      [INDENT * (minus.length-1), '*', ' ', s, EOL].join
    end

    # ol
    rule(:ordered_list => sequence(:lines)) { lines.join }
    rule(:plus => simple(:plus), :item => simple(:s)) do
      [INDENT * (plus.length-1), '1.', ' ', s, EOL].join
    end

    # dl
    rule(:definition_list => sequence(:lines)) { ["<dl>", EOL, *lines, "</dl>", EOL].join }
    rule(:colon => simple(:colon), :term => simple(:term), :description => simple(:desc)) do
      [ INDENT, "<dt>#{term}</dt>", EOL,
        INDENT, "<dd>#{desc}</dd>", EOL ].join
    end

    # break
    rule(:block_margin => simple(:s)) { '<br />' + EOL }

    # separator line
    rule(:separator_line => simple(:s)) { '---' + EOL }

    # horizontal line
    rule(:horizontal_line => simple(:s)) { '---' + EOL }

    # #clear: ignore
    rule(:clear => simple(:s)) { ['<!---', INDENT+'clear', '--->'].join("\n") + EOL }

    # #contents: not supported
    rule(:toc => simple(:s)) { ['<!---', INDENT+'toc', '--->'].join("\n") + EOL }

    # #ls: not supported
    rule(:child_pages => simple(:s)) { ['<!---', INDENT+'ls', '--->'].join("\n") + EOL }

    # paragraph
    rule(:paragraph_lines => sequence(:lines)) { lines.join }

    # block separator
    rule(:block_separator => simple(:s)) { EOL }

    # table
    rule(:header => sequence(:cells), :other_rows => sequence(:rows)) {
      [ %(|#{cells.join('|')}|),
        %(|#{Array.new(cells.size, ' --- ').join('|')}|),
        *rows ].join("\n") + EOL
    }

    rule(:header => sequence(:cells), :other_rows => simple(:not_found)) {
      [ %(|#{cells.join('|')}|),
        %(|#{Array.new(cells.size, ' --- ').join('|')}|),
      ].join("\n") + EOL
    }

    rule(:top_row => sequence(:cells), :other_rows => sequence(:rows)) {
      [ %(|#{Array.new(cells.size, ' ').join('|')}|),
        %(|#{Array.new(cells.size, ' --- ').join('|')}|),
        %(|#{cells.join('|')}|),
        *rows ].join("\n") + EOL
    }

    rule(:top_row => sequence(:cells), :other_rows => simple(:not_found)) {
      [ %(|#{Array.new(cells.size, ' ').join('|')}|),
        %(|#{Array.new(cells.size, ' --- ').join('|')}|),
        %(|#{cells.join('|')}|),
      ].join("\n") + EOL
    }

    rule(:row => sequence(:cells)) {
      %(|#{cells.join('|')}|)
    }

    rule(:cell => simple(:c)) { c }

    # block attachment
    rule(:block_image_url => simple(:url), :l => simple(:l), :r => simple(:r)) {
      attachment = AttachmentURL.new(url)
      "![#{attachment.basename}](#{attachment.url})" + EOL
    }

    rule(:block_file_url => simple(:url), :l => simple(:l), :r => simple(:r)) {
      attachment = AttachmentURL.new(url)
      "[#{attachment.basename}](#{attachment.url})" + EOL
    }

    rule(:block_image => simple(:image), :l => simple(:l), :r => simple(:r)) {
      "![#{image}](#{image})" + EOL
    }

    rule(:block_file => simple(:file), :l => simple(:l), :r => simple(:r)) {
      "[#{file}](#{file})" + EOL
    }

    # inline attachment
    rule(:image_url => simple(:url), :l => simple(:l), :r => simple(:r)) {
      attachment = AttachmentURL.new(url)
      "![#{attachment.basename}](#{attachment.url})"
    }

    rule(:file_url => simple(:url), :l => simple(:l), :r => simple(:r)) {
      attachment = AttachmentURL.new(url)
      "[#{attachment.basename}](#{attachment.url})"
    }

    rule(:image => simple(:image), :l => simple(:l), :r => simple(:r)) {
      "![#{image}](#{image})"
    }

    rule(:file => simple(:file), :l => simple(:l), :r => simple(:r)) {
      "[#{file}](#{file})"
    }

    # strong
    rule(:strong => simple(:strong), :l => simple(:l), :r => simple(:r)) { " **#{strong}** " }

    # italic
    rule(:italic => simple(:italic), :l => simple(:l), :r => simple(:r)) { " _#{italic}_ " }

    # deleted
    rule(:deleted => simple(:deleted), :l => simple(:l), :r => simple(:r)) { " ~~#{deleted}~~ " }

    # footnote
    rule(:footnote => simple(:footnote), :l => simple(:l), :r => simple(:r)) { "(#{footnote})" }

    # plain_text
    rule(:plain_text => simple(:txt)) { txt }

    # inline_text
    rule(:inline_text => sequence(:inline_text)) { inline_text.join }

    # outbound_link
    rule(:link_text => simple(:text), :link_url => simple(:url)) { "[#{text}](#{url})" }

    # inner_link
    rule(:inner_link => simple(:name), :l => simple(:l), :r => simple(:r)) { "[#{name}]" }
  end
end
