[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
] @rainbow.paren

[
  "if"
  "else"
  "elseif"
  "then"
  "for"
  "while"
  "repeat"
  "until"
  "do"
  "function"
  "end"
  (#lua-extended-rainbow-mode?)
] @rainbow.paren

[
  (variable_declaration)
  (local_variable_declaration)
  (function_call)
  (local_function)
  (function)
  (if_statement)
  (for_statement)
  (for_in_statement)
  (repeat_statement)
  (return_statement)
  (while_statement)
  (table)
  (do_statement)
] @rainbow.level
