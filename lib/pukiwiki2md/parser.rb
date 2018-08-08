module Pukiwiki2md
 class Parser < Parslet::Parser
   class_eval(&Pukiwiki2md::BlockElementRules)
   class_eval(&Pukiwiki2md::InlineElementRules)
   class_eval(&Pukiwiki2md::PrimitiveElementRules)
   root :expression
 end
end
