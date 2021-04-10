[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
 "%w("
 "%i("
 "#{"
] @rainbow.paren

[
  "begin"
  "case"
  "def"
  "do"
  "end"
  "end"
  "ensure"
  "for"
  "if"
  "rescue"
  "then"
  "until"
  "when"
  "while"
  (#lua-extended-rainbow-mode?)
] @rainbow.paren

[
  (array)
  (begin)
  (call)
  (case)
  (class)
  (for)
  (if)
  (interpolation)
  (method)
  (parenthesized_statements)
  (until)
  (until_modifier)
  (while)
  (while_modifier)
] @rainbow.level
