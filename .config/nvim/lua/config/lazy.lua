-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.termguicolors = true

local opt = vim.opt
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.mouse = "a"
opt.expandtab = true
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.smartcase = true
opt.ignorecase = true
opt.smartindent = true
opt.undofile = true
opt.undolevels = 10000
opt.sidescrolloff = 4
opt.shiftround = true
opt.tabstop = 2
opt.number = true
opt.relativenumber = true
opt.smoothscroll = true
opt.swapfile = false
opt.wrap = true
opt.linebreak = true
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true
opt.cursorline = true

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
		{
			"folke/tokyonight.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
			init = function()
				-- load the colorscheme here
				-- vim.cmd([[colorscheme tokyonight]])
				vim.cmd.colorscheme("tokyonight-night")
				vim.cmd.hi("Comment gui=none")
			end,
		},
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.keymap.set("n", "<leader>e", "<cmd>Explore<cr>", { desc = "File explorer" })
vim.keymap.set("x", "p", "P")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
