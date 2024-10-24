local M = {}

-- Default configurations
local defaults = {
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
	-- Custom functions with their default and focus states
	customs = {
		-- Example of a custom function configuration:
		-- statusline = {
		--     default = function() vim.opt.statusline = "%f" end,
		--     focus = function() vim.opt.statusline = "" end,
		-- },
	},
	-- Callbacks
	on_enter = nil,
	on_exit = nil,
}

M.focus_active = false
M.config = {}
local original_values = {}

local function apply_custom_functions(mode)
	for _, custom in pairs(M.config.customs) do
		if type(custom[mode]) == "function" then
			custom[mode]()
		end
	end
end

function M.toggle_focus()
	if not M.focus_active then
		-- Save and apply focus options
		for option, focus_value in pairs(M.config.options) do
			if pcall(function() return vim.opt[option] end) then
				original_values[option] = vim.opt[option]:get()
				vim.opt[option] = focus_value
			end
		end

		-- Apply focus custom functions
		apply_custom_functions("focus")

		-- Call on_enter callback if defined
		if M.config.on_enter then
			M.config.on_enter()
		end

		M.focus_active = true
	else
		-- Restore original options
		for option, value in pairs(original_values) do
			if pcall(function() return vim.opt[option] end) then
				vim.opt[option] = value
			end
		end

		-- Apply default custom functions
		apply_custom_functions("default")

		-- Call on_exit callback if defined
		if M.config.on_exit then
			M.config.on_exit()
		end

		M.focus_active = false
	end

end

function M.setup(user_opts)
	user_opts = user_opts or {}

	-- Merge user config with defaults
	M.config = vim.tbl_deep_extend("force", defaults, user_opts)

	-- Create command
	vim.api.nvim_create_user_command('Focus', function()
		M.toggle_focus()
	end, {})

	-- Set up keymaps if provided
	if user_opts.keymaps then
		for mode, mappings in pairs(user_opts.keymaps) do
			for lhs, rhs in pairs(mappings) do
				local cmd = type(rhs) == "table"
				and rhs.cmd
				or "Focus"
				local keymap_opts = type(rhs) == "table"
				and rhs.opts
				or { desc = "Toggle focus mode" }

				vim.keymap.set(mode, lhs, "<cmd>" .. cmd .. "<CR>", keymap_opts)
			end
		end
	end
end

return M
