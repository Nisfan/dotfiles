return {
	{
		"stevearc/conform.nvim",
		dependencies = { "mason.nvim" },
		event = { "BufWritePre" },
		cmd = "ConformInfo",
		opts = {
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters_by_ft = {
				lua = { "stylua" },
				php = { "php_cs_fixer", "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				xml = { "prettierd", "prettier", stop_after_first = true },
				blade = { "prettierd", "prettier", stop_after_first = true },
				rust = { "rustfmt" },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
			-- formatters = {
			-- 	["php-cs-fixer"] = {
			-- 		command = "php-cs-fixer",
			-- 		args = {
			-- 			"fix",
			-- 			"--rules=@PSR12", -- Formatting preset. Other presets are available, see the php-cs-fixer docs.
			-- 			"$FILENAME",
			-- 		},
			-- 		stdin = false,
			-- 	},
			-- },
			notify_on_error = true,
		},
		-- opts = function()
		--   ---@type conform.setupOpts
		--   local opts = {
		--     default_format_opts = {
		--       timeout_ms = 3000,
		--       async = false,           -- not recommended to change
		--       quiet = false,           -- not recommended to change
		--       lsp_format = "fallback", -- not recommended to change
		--     },
		--     formatters_by_ft = {
		--       lua = { "stylua" },
		--       fish = { "fish_indent" },
		--       sh = { "shfmt" },
		--     },
		--     formatters = {
		--       injected = { options = { ignore_errors = true } },
		--     },
		--   }
		--   return opts
		-- end,
		-- config = function()
		--   vim.api.nvim_create_autocmd("BufWritePre", {
		--     group = vim.api.nvim_create_augroup("custom-conform", { clear = true }),
		--     callback = function(args)
		--       require("conform").format({
		--         bufnr = args.buf,
		--         lsp_fallback = true,
		--         quiet = true,
		--       })
		--     end,
		--   })
		-- end,
	},
}
