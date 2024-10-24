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
  -- optionally lazyload on cmd or keybind event
  cmd = { "Focus", "FocusOn", "FocusOff" },
  keys = {{ "<leader>tf", "<cmd>Focus<cr>", desc = "Toggle focus mode" }},
  -- if you are using filetypes make sure to add them here as well
  ft = { "markdown", "text" },
}
```

### Usage

You can toggle focus mode with `:Focus`, or manually turn it on and off with
`:FocusOn` or `:FocusOff`
or with lua:
```lua
local focus = require("focus")

focus.activate()
focus.deactivate()
focus.toggle()
```

## Customization

You can customize the plugin behavior by passing some options via setup or lazy opts
> These are the defaults, if you are ok with them, you can just call setup() or opts = {}
> You can see some examples commented out
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

  filetypes = {
    -- "markdown",
    -- "text",
  },

  -- Custom functions, I use those for any custom vim functionality like
  -- changing colors or interacting with other plugins
  customs = {
    -- colors = {
    --   default = function()
    --     vim.cmd[[
    --       highlight Normal guibg=#1a1b26
    --       highlight LineNr guifg=#545c7e
    --     ]]
    --   end,
    --   focus = function()
    --     vim.cmd[[
    --       highlight Normal guibg=#000000
    --       highlight LineNr guifg=#303030
    --     ]]
    --   end
    -- },
  },

  -- You can set keymaps in options as well
  keymaps = {
    --   n = {
    --     ["<leader>tf"] = { cmd = "Focus", opts = { desc = "Toggle focus mode" } },
    --   },
  },

  on_enter = nil, -- Execute upon entering focus mode
  on_exit = nil, -- Execute upon leaving focus mode
  -- example for configuring external tools like tmux
  -- on_enter = function()
  --   vim.fn.system("tmux set status on")
  -- end,
  --
  -- on_exit = function()
  --   vim.fn.system("tmux set status off")
  -- end,
}
```
