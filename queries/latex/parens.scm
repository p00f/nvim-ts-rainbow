; inherits: square,round,curly
"$" @left
(_ "\\[" @left "\\]" @right)
(_ "\\(" @left "\\)" @right)

[
 "\\begin"
 (#latex-extended-rainbow-mode?)] @left
[
 "\\end"
 (#latex-extended-rainbow-mode?)] @right
