# nvim-ts-rainbow
Rainbow parens for neovim using tree-sitter. Needs [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## Setup
```lua
require'nvim-treesitter.config'.setup {
  rainbow = {
    enable = true
    disable = {'lua'}
  }
}
```

## Credits
Huge thanks to @vigoux, @theHamsta, @sogaiu and @steelsojka for all their help
