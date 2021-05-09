  (_ "{" @left "}" @right)
  (_ "(" @left ")" @right)
  (_ "[" @left "]" @right)
  "$" @left
  (_ "\\[" @left "\\]" @right)
  (_ "\\(" @left "\\)" @right)


  (_ "\\begin" @left "\\end" @right)
  (#latex-extended-rainbow-mode?)
