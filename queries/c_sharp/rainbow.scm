[
  "["
  "]"
  "{"
  "}"
  "("
  ")"
] @rainbow.paren

(type_argument_list
  ["<" ">"] @rainbow.paren)

[
  (class_declaration)
  (enum_declaration)
  (interface_declaration)
  (method_declaration)
  (namespace_declaration)

  (do_statement)
  (invocation_expression)
  (array_rank_specifier)
  (object_creation_expression)
  (for_statement)
  (if_statement)
  (switch_statement)
  (try_statement)
  (while_statement)

  (parenthesized_expression)
  (initializer_expression)
] @rainbow.level
