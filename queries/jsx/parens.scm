; inherits: square,round,curly

[(jsx_opening_element
   name: (identifier) @left
   attribute: (jsx_attribute (property_identifier) @left
                             (string)))
 (jsx-extended-rainbow-mode?)]

"<" @left
">" @right

[(jsx_opening_element
   name: (identifier) @left)
 (jsx-extended-rainbow-mode?)]

[(jsx_closing_element)
 (jsx-extended-rainbow-mode?)] @right
