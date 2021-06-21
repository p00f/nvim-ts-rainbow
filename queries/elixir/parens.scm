; inherits: square,round,curly
(binary
  "<<" @left
  ">>" @right)
(map
  "%{" @left
  "}" @right)
(struct
  "%" @left
  "{" @left
  "}" @right)
(interpolation
  "#{" @left
  "}" @right)
(sigil
  (sigil_start) @left
  (sigil_end) @right)
