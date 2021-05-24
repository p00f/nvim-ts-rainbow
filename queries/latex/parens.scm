; inherits: square,round,curly
"$" @left
(_ "\\[" @left "\\]" @right)
(_ "\\(" @left "\\)" @right)

; TODO: broken
(_
 "\\begin" @left
 "\\end" @right
 (#latex-extended-rainbow-mode?))
