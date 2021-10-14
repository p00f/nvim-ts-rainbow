; inherits: square,round,curly
"$" @left
"\\[" @left
"\\]" @right
"\\(" @left
"\\)" @right

[
 "\\begin"
 (#latex-extended-rainbow-mode?)] @left
[
 "\\end"
 (#latex-extended-rainbow-mode?)] @right
