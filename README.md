# nvim-ts-rainbow
Rainbow parens for neovim using tree-sitter. Needs [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

## Setup
```lua
require'nvim-treesitter.config'.setup {
  rainbow = {
    enable = true
    disable = {'lua'} --please disable lua for now
  }
}
```
## Screenshots
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/java.png)
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/clojure.png)
![alt text](https://raw.githubusercontent.com/p00f/nvim-ts-rainbow/master/screenshots/fennel.png)
## Credits
Huge thanks to @vigoux, @theHamsta, @sogaiu and @steelsojka for all their help
