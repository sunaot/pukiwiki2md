module Pukiwiki2md
  PrimitiveElementRules = proc {
    rule(:space) {
      match('[ \t]').repeat(1)
    }

    rule(:space?) {
      space.maybe
    }

    rule(:eol) {
      match('[\r\n]')
    }

    rule(:string) {
      (eol.absent? >> any).repeat(1)
    }

    rule(:char) {
      eol.absent? >> any
    }

    rule(:scheme) { str('http') >> str('s').maybe }
  }
end
