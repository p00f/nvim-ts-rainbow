[
  "{"
  "}"
  "["
  "]"
  "("
  ")"
] @rainbow.paren

(interpolation
 ["${" "}"] @rainbow.paren)

[
  (attrset)
  (interpolation)
  (parenthesized)
  (list)
] @rainbow.level
