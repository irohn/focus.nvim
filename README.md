# focus
A plugin to help you focus by removing clutter and distractions (using [vim-yin-yang](https://github.com/pgdouyon/vim-yin-yang) colorscheme by pgdouyon)

![before](https://raw.githubusercontent.com/irohn/focus.nvim/refs/heads/master/images/before.png)
![after](https://raw.githubusercontent.com/irohn/focus.nvim/refs/heads/master/images/after.png)

## Getting Started

### Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
  "irohn/focus.nvim",
  opts = {},
  -- cmd = "Focus", -- optionally lazyload
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
  -- vim.opt options that you wish to change when entering focus mode,
  -- these options will revert back to what they were previously set to.
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
  customs = {}, -- custom options
  on_enter = nil, -- Execute upon entering focus mode
  on_exit = nil, -- Execute upon leaving focus mode
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

  -- example for configuring external tools like tmux
  on_enter = function()
    vim.fn.system("tmux set status on")
  end,

  on_exit = function()
    vim.fn.system("tmux set status off")
  end,
}
```
