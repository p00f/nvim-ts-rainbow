lua require "rainbow".init()
autocmd ColorScheme * lua require "rainbow.internal".defhl()
autocmd CursorMoved * lua require "rainbow.internal".full_update(0)
