# 🌈 nvim-ts-rainbow 🌈
Rainbow parentheses for neovim using tree-sitter. Needs [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

Tested languages - lua, java, clojure, fennel, python, css, rust, cpp. Should work with any language supported by nvim-treesitter. If any language is missing, please open an issue/PR.


## Setup
```lua
require'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true
  }
}
```

### Colours
I've used the gruvbox palette because it is nice and subtle. I wanted to use VIBGYOR for an actual rainbow, but
 - indigo and blue look the same.
 - the colours were too bright and distracting.

To change the colours, edit `lua/rainbow/colors.lua`. If you want to override only a *few* colours (you can only change colours 1 through 7 this way), you can do it in your init.vim: (thanks @delphinus !)
```vim
hi rainbowcol1 guifg=#123456
```
## Screenshots
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/java.png)
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/clojure.png)
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/fennel.png)
## Credits
Huge thanks to @vigoux, @theHamsta, @sogaiu, @bfredl and @sunjon and @steelsojka for all their help
