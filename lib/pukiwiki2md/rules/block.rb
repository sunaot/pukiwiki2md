module Pukiwiki2md
  BlockElementRules = proc {
    class << self
      def markup(char, name)
        rule(name.to_sym) {
          str(char)
        }
      end

      def keyword(tag, name)
        rule(name.to_sym) {
          str(tag.to_s).as(name.to_sym) >> eol
        }
      end
    end

    rule(:expression) {
      page_text >> space?
    }

    rule(:page_text) {
      page_components.repeat.as(:page_components)
    }

    rule(:page_components) {
      block_separator |
      contents
    }

    rule(:contents) {
      header |
      quote |
      horizontal_line | # must be prior to list (ul)
      list |
      preformatted |
      block_margin |
      separator_line |
      child_pages |
      table |
      block_attachment |
      clear |
      toc |
      paragraph
    }

    rule(:paragraph) {
      (match('[ *>\-\+]').absent? >> inline_text.as(:line) >> eol).repeat(1).as(:paragraph_lines)
    }

    rule(:quote) {
      (gt >> space? >> inline_text.maybe.as(:line) >> eol).repeat(1).as(:quote_lines)
    }

    rule(:list) {
      (unordered_list | ordered_list | definition_list)
    }

    rule(:unordered_list) {
      ulist_item.repeat(1).as(:unordered_list)
    }

    rule(:ulist_item) {
      minus.repeat(1,3).as(:minus) >> space? >> inline_text.maybe.as(:item) >> eol
    }

    rule(:ordered_list) {
      olist_item.repeat(1).as(:ordered_list)
    }

    rule(:olist_item) {
      plus.repeat(1,3).as(:plus) >> space? >> inline_text.maybe.as(:item) >> eol
    }

    rule(:definition_list) {
      dlist_item.repeat(1).as(:definition_list)
    }

    rule(:dlist_item) {
      dlist_term >> dlist_description >> eol
    }

    rule(:dlist_term) {
      colon.repeat(1,3).as(:colon) >> space? >> dlist_term_text.maybe.as(:term)
    }

    rule(:dlist_term_text) {
      (vertical_bar.absent? >> any).repeat(1)
    }

    rule(:dlist_description) {
      vertical_bar >> space? >> string.maybe.as(:description)
    }

    rule(:preformatted) {
      (monospace >> string.maybe.as(:line) >> eol).repeat(1).as(:preformatted_lines)
    }

    rule(:header) {
      star.repeat(1,6).as(:star) >> space? >> inline_text_with_fragment.maybe.as(:header) >> eol
    }

    # Ignore `LEFT:`, `CENTER:`, `RIGHT:`

    # PukiWiki spec:
    #   - `----abc` is available (no space needed).
    #   - PukiWiki regards `---` as an unordered list.
    rule(:horizontal_line) {
      (str('----') >> string.repeat.maybe).as(:horizontal_line) >> eol
    }

    rule(:block_attachment) {
      str('#ref(').as(:l) >> block_attachment_path >> str(')').as(:r) >> eol
    }

    rule(:block_attachment_path) {
      space? >> (
        block_attachment_image_url.as(:block_image_url) |
        block_attachment_file_url.as(:block_file_url) |
        block_attachment_image.as(:block_image) |
        block_attachment_file.as(:block_file)
      ) >> space?
    }

    rule(:block_attachment_file_url) {
      scheme >> str('://') >> block_attachment_file
    }

    rule(:block_attachment_image_url) {
      scheme >> str('://') >> block_attachment_image
    }

    rule(:block_attachment_file) {
      (str(')').absent? >> any).repeat(1)
    }

    rule(:block_attachment_image) {
      block_attachment_image_base >> image_extension
    }

    rule(:block_attachment_image_base) {
      ((rparen|image_extension).absent? >> any).repeat(1)
    }

    rule(:image_extension) { dot >> (jpg|gif|png) }

    rule(:jpg) { str('jpg') | str('jpeg') | str('JPG') | str('JPEG') }

    rule(:gif) { str('gif') | str('GIF') }

    rule(:png) { str('png') | str('PNG') }

    rule(:block_separator) {
      eol.repeat(1).as(:block_separator)
    }

    rule(:table) {
      table_rows
    }

    rule(:table_rows) {
      table_top_row >> table_other_rows.maybe.as(:other_rows)
    }

    rule(:table_top_row) {
      table_header_row.as(:header) |
      table_false_header_row.as(:top_row)
    }

    rule(:table_other_rows) {
      table_detail_row.repeat(1)
    }

    rule(:table_header_row) {
      vertical_bar >> table_cells >> str('h') >> eol
    }

    rule(:table_false_header_row) {
      vertical_bar >> table_cells >> eol
    }

    rule(:table_detail_row) {
      vertical_bar >> table_cells.as(:row) >> eol
    }

    rule(:table_cells) {
      (table_cell.maybe.as(:cell) >> vertical_bar).repeat(1)
    }

    rule(:table_cell) {
      (vertical_bar.absent? >> char).repeat
    }

    # Ignore forms (comment, pcomment, article, vote)

    markup('~', :tilde)
    markup('>', :gt)
    markup('-', :minus)
    markup('+', :plus)
    markup(':', :colon)
    markup('|', :vertical_bar)
    markup(' ', :monospace)
    markup(',', :comma)
    markup('.', :dot)
    markup('*', :star)
    markup('(', :lparen)
    markup(')', :rparen)
    keyword('#br', :block_margin)
    keyword('#clear', :clear)
    keyword('#hr', :separator_line)
    keyword('#contents', :toc)
    keyword('#ls', :child_pages)
  }
end
