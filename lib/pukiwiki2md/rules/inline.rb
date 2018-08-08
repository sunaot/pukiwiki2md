module Pukiwiki2md
  InlineElementRules = proc {
    rule(:inline_text) {
      inline_text_item.repeat(1).as(:inline_text)
    }

    rule(:inline_text_item) {
      enclosed_text |
      inline_function_text |
      plain_text 
    }

    rule(:inline_text_with_fragment) {
      (enclosed_text |
       inline_function_text |
       fragment |
       plain_text_for_header).repeat(1).as(:inline_text)
    }

    rule(:enclosed_text) {
      italic | # must be prior to strong
      strong |
      deleted |
      footnote
    }

    rule(:inline_function_text) {
      break_line |
      inline_attachment |
      outbound_link |
      inner_link
    }

    rule(:fragment) {
      (str('[#') >> fragment_hash >> str(']')).as(:fragment)
    }

    rule(:fragment_hash) {
      match('[a-z0-9]').repeat(8,8)
    }

    rule(:plain_text) {
      (enclosed_text.absent? >> inline_function_text.absent? >> char).repeat(1).as(:plain_text)
    }

    rule(:plain_text_for_header) {
      (enclosed_text.absent? >>
       inline_function_text.absent? >>
       fragment.absent? >>
       char).repeat(1).as(:plain_text)
    }

    rule(:strong) {
      str("''").as(:l) >> strong_text.as(:strong) >> str("''").as(:r)
    }

    rule(:strong_text) {
      (str("''").absent? >> char).repeat(1)
    }

    rule(:italic) {
      str("'''").as(:l) >> italic_text.as(:italic) >> str("'''").as(:r)
    }

    rule(:italic_text) {
      (str("'''").absent? >> char).repeat(1)
    }

    rule(:deleted) {
      str('%%').as(:l) >> deleted_text.as(:deleted) >> str('%%').as(:r)
    }

    rule(:deleted_text) {
      (str('%%').absent? >> char).repeat(1)
    }

    rule(:footnote) {
      str('((').as(:l) >> footnote_text.as(:footnote) >> str('))').as(:r)
    }

    rule(:footnote_text) {
      (str('))').absent? >> char).repeat(1)
    }

    rule(:break_line) { str('&br;') }

    rule(:inline_attachment) {
      str('&ref(').as(:l) >> inline_attachment_path >> str(');').as(:r)
    }

    rule(:inline_attachment_path) {
      space? >> (
        inline_attachment_image_url.as(:image_url) |
        inline_attachment_file_url.as(:file_url) |
        inline_attachment_image.as(:image) |
        inline_attachment_file.as(:file)
      ) >> space?
    }

    rule(:inline_attachment_image_url) {
      scheme >> str('://') >> inline_attachment_image
    }

    rule(:inline_attachment_file_url) {
      scheme >> str('://') >> inline_attachment_file
    }

    rule(:inline_attachment_image) {
      inline_attachment_image_base >> image_extension
    }

    rule(:inline_attachment_file) {
      (str(');').absent? >> char).repeat(1)
    }

    rule(:inline_attachment_image_base) {
      ((str(');')|image_extension).absent? >> char).repeat(1)
    }

    # [[name>alias]] could be used as an alias name for WikiName page, but this library ignores it and parses only outbound link URL.
    rule(:outbound_link) {
      str('[[') >> space? >>
        link_text.as(:link_text) >>
        link_separator >> space? >>
        link_url.as(:link_url) >>
      str(']]')
    }

    rule(:link_text) {
      link_text_body_1st_part >>
      (link_separator >> space? >> link_text_body_2nd_part).repeat
    }

    rule(:link_text_body) {
      (link_separator.absent? >> char).repeat(1)
    }

    rule(:link_text_body_1st_part) {
      link_text_body.maybe >> link_separator.present?
    }

    rule(:link_text_body_2nd_part) {
      scheme.absent? >> link_text_body.maybe >> link_separator.present?
    }

    rule(:link_url) {
      scheme >> str('://') >> (str(']]').absent? >> char).repeat(1)
    }

    rule(:link_separator) { match('[:>]') }

    rule(:inner_link) {
      str('[[').as(:l) >> inner_link_text.as(:inner_link) >> str(']]').as(:r)
    }

    rule(:inner_link_text) {
      (str(']]').absent? >> char).repeat(1)
    }
  }
end
