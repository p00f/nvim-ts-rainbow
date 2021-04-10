[
  "{"
  "}"
  "("
  ")"
  "["
  "]"
  "$"
  "\\["
  "\\]"
  "\\("
  "\\)"
] @rainbow.paren


[
  "\\begin"
  "\\end"
  (#latex-extended-rainbow-mode?)
] @rainbow.paren

[
  (key_val_options)
  (brace_group)
  (environment)
] @rainbow.level
