# focus

## Getting Started

### Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "irohn/focus.nvim",
  opts = {},
  cmd = "Focus",
}
```

### Usage

Using the command `:Focus` will toggle the focus mode

You can create a keymap:
```lua
vim.keymap.set("n", "<leader>z", "<cmd>Focus<cr>", { desc = "Toggle focus mode" })
```

### Customization

You can customize the plugin behavior by passing some options via setup or lazy itself
> These are the defaults, if you are ok with them, you can just call setup()
```lua
require("focus").setup {
  options = {
    number = false,
    relativenumber = false,
    signcolumn = "yes:3",
    colorcolumn = {0},
    laststatus = 0,
    showmode = false,
    ruler = false,
    showcmd = false,
    cmdheight = 0,
  },
  customs = {},
  on_enter = nil,
  on_exit = nil,
}
```

You can customize even further, see this example:
```lua
require("focus").setup {
  -- Add custom functions
  customs = {
    colors = {
      default = function()
        vim.cmd[[
          highlight Normal guibg=#1a1b26
          highlight LineNr guifg=#545c7e
        ]]
      end,
      focus = function()
        vim.cmd[[
          highlight Normal guibg=#000000
          highlight LineNr guifg=#303030
        ]]
      end
    },
  },

  -- Add keymaps
  keymaps = {
    n = {
      ["<leader>tf"] = { cmd = "Focus", opts = { desc = "Toggle focus mode" } },
    },
  },

}
```
