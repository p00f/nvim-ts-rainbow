; inherits: square,round,curly

(if_statement
    ["if" "then" "end"] @if
    (#lua-extended-rainbow-mode? @if)
)

(elseif_statement
    ["elseif" "then"] @elseif
    (#lua-extended-rainbow-mode? @elseif)
)

(else_statement
    ["else" "end"] @else
    (#lua-extended-rainbow-mode? @else)
)
