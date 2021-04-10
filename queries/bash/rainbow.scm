[
  "{"
  "}"
  "["
  "]"
  "("
  ")"
  "[["
  "]]"
  "(("
  "))"
] @rainbow.paren

(command_substitution
  [ "$(" ")" ] @rainbow.paren)
(expansion
  [ "${" "}" ] @rainbow.paren)

[
  "case"
  "in"
  "esac"
  "if"
  "elif"
  "then"
  "fi"
  (#bash-extended-rainbow-mode?)
] @rainbow.paren

[
  (function_definition)
  (if_statement)
  (case_statement)
  (while_statement)
  (c_style_for_statement)
  (for_statement)
  (variable_assignment)
  (command)
] @rainbow.level
