["{" "}" "[" "]" "(" ")"] @rainbow.paren

(template_argument_list
  ["<" ">"] @rainbow.paren)

(template_parameter_list
  ["<" ">"] @rainbow.paren)

[
  (array_declarator)
  (call_expression)
  (compound_statement)
  (enumerator_list)
  (field_declaration_list)
  (initializer_list)
  (parameter_list)
  (condition_clause)
  (template_parameter_list)
  (declaration_list)
] @rainbow.level

(type_definition (template_type) @rainbow.level)
