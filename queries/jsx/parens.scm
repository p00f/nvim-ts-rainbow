; inherits: square,round,curly

((jsx_opening_element
   ["<" ">"] @left-delimiters
   name: _ @left
 ) (#jsx-extended-rainbow-mode?))

((jsx_self_closing_element
   ; Combining "/" with "<" results in "invalid node type" treesitter error
   ["<" "/" ">"] @self-closing-delimiters
   name: _ @self-closing
 ) (#jsx-extended-rainbow-mode?))

((jsx_closing_element
   ; Combining "/" with ">" results in "invalid node type" treesitter error
   ["<" "/" ">"] @right-delimiters
   name: _ @right
 ) (#jsx-extended-rainbow-mode?))

; [(jsx_element
;    open_tag: (jsx_opening_element) @left
;    close_tag: (jsx_closing_element) @right)
;  (#jsx-extended-rainbow-mode?)]
