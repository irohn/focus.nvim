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

function M.activate()
	if M.focus_active then
		return
	end

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
end

function M.deactivate()
	if not M.focus_active then
		return
	end

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

function M.toggle_focus()
	if M.focus_active then
		M.deactivate()
	else
		M.activate()
	end
end

function M.setup(user_opts)
	user_opts = user_opts or {}

	-- Merge user config with defaults
	M.config = vim.tbl_deep_extend("force", defaults, user_opts)

	local group = vim.api.nvim_create_augroup('Focus', { clear = true })

	-- Create autocommand to deactivate focus mode before vim quits
	vim.api.nvim_create_autocmd('VimLeavePre', {
		group = group,
		callback = function()
			M.deactivate()
		end,
	})

	-- Create command
	vim.api.nvim_create_user_command('Focus', function()
		M.toggle_focus()
	end, {})

	vim.api.nvim_create_user_command('FocusOn', function()
		M.activate()
	end, {})

	vim.api.nvim_create_user_command('FocusOff', function()
		M.deactivate()
	end, {})

	-- Set up autocommands for specific filetypes if provided
	if user_opts.filetypes then

		for _, ft in ipairs(user_opts.filetypes) do
			vim.api.nvim_create_autocmd('FileType', {
				group = group,
				pattern = ft,
				callback = function()
					M.activate()

					-- Create buffer-local autocmd to deactivate on leaving
					vim.api.nvim_create_autocmd('BufLeave', {
						buffer = 0,  -- current buffer
						group = group,
						callback = function()
							M.deactivate()
						end,
						once = true  -- cleanup after triggering
					})
				end,
			})
		end
	end

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
