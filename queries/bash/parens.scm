["{" "}" "[" "]" "(" ")"] @paren
(command_substitution
  [ "$(" ")" ] @paren)
(expansion
  [ "${" "}" ] @paren)
