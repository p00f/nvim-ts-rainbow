# 🌈 nvim-ts-rainbow 🌈
Rainbow parentheses for neovim using tree-sitter. Needs [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

Tested languages - lua, java, clojure, fennel, python, css, rust, cpp. Should work with any language supported by nvim-treesitter. If any language is missing, please open an issue/PR.


## Installation and setup
Install this plugin, then
```lua
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
}
```

### Colours
I've used the gruvbox palette because it is nice and subtle. I wanted to use VIBGYOR for an actual rainbow, but
 - indigo and blue look the same.
 - the colours were too bright and distracting.

To change the colors you can edit `lua/rainbow/colors.lua` or add following code to setup
```lua
require'nvim-treesitter.configs'.setup{
  rainbow = {
    -- Setting colors
    colors = {
      -- Colors here
    },
    -- Term colors
    termcolors = {
      -- Term colors here
    }
  },
}
```

If you want to override some colours (you can only change colours 1 through 7 this way), you can do it in your init.vim: (thanks @delphinus !). You can also use this while writing a colorscheme
```vim
hi rainbowcol1 guifg=#123456
```
## Screenshots
 - Java

![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/java.png)

The screenshots below use a different colorscheme
 - Fennel:

![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/fnlwezterm.png)
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/fnltreesitter.png)
 - C++:

![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/cpp.png)
 - Latex (with tag begin-end matching)

![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/latex_.png)
## Credits
Huge thanks to @vigoux, @theHamsta, @sogaiu, @bfredl and @sunjon and @steelsojka for all their help
