--- CHANGE THESE
local pattern = "typescript"
local cmd = { "typescript-language-server", "--stdio" }
-- Add files/folders here that indicate the root of a project
local root_markers = { ".git", ".editorconfig" }
-- Change to table with settings if required
local settings = vim.empty_dict()

local function LspStop()
	vim.lsp.stop_client(vim.lsp.get_active_clients())
end

local function LspStart()
	local match = vim.fs.find(root_markers, { path = vim.fn.expand('%'), upward = true })[1]
	local root_dir = match and vim.fn.fnamemodify(match, ":p:h") or nil
	vim.lsp.start({
		name = "tsserver",
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
	})
end

vim.api.nvim_create_user_command("LspStop", LspStop, { nargs = 0 })
vim.api.nvim_create_user_command("LspStart", LspStart, { nargs = 0 })

vim.api.nvim_create_autocmd("FileType", {
	pattern = pattern,
	callback = function(args)
		local match = vim.fs.find(root_markers, { path = args.file, upward = true })[1]
		local root_dir = match and vim.fn.fnamemodify(match, ":p:h") or nil
		vim.lsp.start({
			name = "tsserver",
			cmd = cmd,
			root_dir = root_dir,
			settings = settings,
		})
	end,
})
