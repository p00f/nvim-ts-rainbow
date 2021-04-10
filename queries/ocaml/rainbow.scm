[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
  "|"
  "[|"
  "|]"
  "[<"
  "[>"
] @rainbow.paren

[
  "do"
  "done"
  (#ocaml-extended-rainbow-mode?)
] @rainbow.paren

[
  (let_expression)
  (parenthesized_expression)
  (list_expression)
  (do_clause)
  (record_expression)
] @rainbow.level
