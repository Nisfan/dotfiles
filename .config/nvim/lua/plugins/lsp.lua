return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
			"stevearc/conform.nvim",
		},
		-- example using `opts` for defining servers
		-- opts = {
		--   servers = {
		--     lua_ls = {},
		--   },
		-- },
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup()

			vim.api.nvim_create_autocmd("CursorHold", {
				callback = function()
					vim.diagnostic.open_float(nil, { focusable = false })
				end,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- NOTE: Remember that Lua is a real programming language, and as such it is possible
					-- to define small helper and utility functions so you don't have to repeat yourself.
					--
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("<C-k>", vim.lsp.buf.signature_help, "Signature Help")
					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("gd", function()
						require("telescope.builtin").lsp_definitions({
							buffer = {
								initial_mode = "normal",
							},
						})
					end, "[G]oto [D]efinition")

					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					-- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					-- map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					-- map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					-- map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					-- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					-- 	map("<leader>th", function()
					-- 		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					-- 	end, "[T]oggle Inlay [H]ints")
					-- end
				end,
			})

			-- local on_attach = function(client, bufnr)
			--   -- Enable completion triggered by <c-x><c-o>
			--   -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
			--
			--   -- Mappings.
			--   -- See `:help vim.lsp.*` for documentation on any of the below functions
			--   local bufopts = { noremap = true, silent = true, buffer = bufnr }
			--   vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
			--   vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
			--   vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
			--   vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
			--   vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
			--   vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
			--   vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
			--   vim.keymap.set('n', '<space>wl', function()
			--     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			--   end, bufopts)
			--   vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
			--   vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
			--   vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
			--   vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
			--   vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
			-- end

			local lspconfig = require("lspconfig")
			-- local capabilities = vim.lsp.protocol.make_client_capabilities()
			-- capabilities =
			-- 	vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities(capabilities))

			local tsserver_inlay_hints_settings = {
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			}

			local servers = {
				ts_ls = {
					settings = {
						javascript = {
							inlayHints = tsserver_inlay_hints_settings,
						},
						javascriptreact = {
							inlayHints = tsserver_inlay_hints_settings,
						},
						typescript = {
							inlayHints = tsserver_inlay_hints_settings,
						},
						typescriptreact = {
							inlayHints = tsserver_inlay_hints_settings,
						},
					},
				},
				phpactor = {
					filetypes = { "php", "blade", "php_only" },
					init_options = {
						["language_server_worse_reflection.inlay_hints.enable"] = true,
						["language_server_worse_reflection.inlay_hints.params"] = true,
						["language_server_worse_reflection.inlay_hints.types"] = true,
						["language_server_completion.trim_leading_dollar"] = true,
					},
				},
				-- emmet_language_server = {
				-- 	filetypes = {
				-- 		"html",
				-- 		"css",
				-- 		"javascript",
				-- 		"typescript",
				-- 		"javascriptreact",
				-- 		"typescriptreact",
				-- 		"php",
				-- 		"blade",
				-- 		"php_only",
				-- 	},
				-- },
				cssls = {},
				html = {},
				jsonls = {
					settings = {
						validate = { enable = true },
					},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							inlayHints = {
								typeHints = true,
								parameterHints = true,
								chainingHints = true,
								maxLength = 120,
							},
						},
					},
				},
				marksman = {},
				yamlls = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							hint = {
								enable = true,
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			-- for server, config in pairs(opts.servers) do
			-- local capabilities = require("blink.cmp").get_lsp_capabilities()
			--   lspconfig[server].setup(config);
			-- end
			require("mason-lspconfig").setup({
				automatic_installation = false,
				handlers = {
					function(server_name)
						-- require("lspconfig")[server_name].setup({})
						local server = servers[server_name] or {}

						server.capabilities = require("blink.cmp").get_lsp_capabilities(server.capabilities)
						lspconfig[server_name].setup(server)
					end,
				},
			})
		end,
		-- config = function(_, opts)
		--   local lspconfig = require('lspconfig')
		--   for server, config in pairs(opts.servers) do
		--     -- passing config.capabilities to blink.cmp merges with the capabilities in your
		--     -- `opts[server].capabilities, if you've defined it
		--     config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
		--     lspconfig[server].setup(config)
		--   end
		-- end
	},
}
