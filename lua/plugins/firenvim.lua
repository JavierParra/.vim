local spec = {
	'glacambre/firenvim',
	build = ":call firenvim#install(0)",
	lazy = true,
	module = false,
}

if vim.g.started_by_firenvim == true then
	spec = {
		{"vim-airline/vim-airline", cond = false },
		vim.tbl_extend("force", spec, {
			lazy = false, -- must load at start in browser
			init = function ()
				vim.opt.showtabline = 0
			end,
			opts = {
				globalSettings = {
					alt = 'all',
				},
				localSettings = {
					["^https?:\\/\\/(www\\.)?notion\\.so\\/"] = {
						takeover = "never",
					},
					["^about:blank$"] = {
						takeover = "never",
					},
					["^https?:\\/\\/(www\\.)?docs\\.google\\.com\\/"] = {
						takeover = "never",
					},
					["^https?:\\/\\/(www\\.)?figma\\.com\\/"] = {
						takeover = "never",
					},
					["^https?:\\/\\/(www\\.)?interactive-examples\\.mdn\\.mozilla\\.net\\/"] = {
						takeover = "never",
					},
					["^https?:\\/\\/(www\\.)?github\\.com\\/"] = {
						-- selector = 'textarea:not(#pull_request_review_body, #read-only-cursor-text-area)',
						selector = 'textarea[name="comment[body]"]',
					},
					["^https?:\\/\\/localhost:3000/docs"] = {
						takeover = "never",
					},
					["^https?:\\/\\/app.retrium.com"] = {
						takeover = "never",
					},
					["^https?:\\/\\/(staging.)?gamma.app/docs"] = {
						takeover = "never",
					},
					["^https?:\\/\\/visualize\\.graphy\\.app"] = {
						takeover = "never",
					},
					["^https?:\\/\\/app\\.coderpad\\.io"] = {
						takeover = "never",
					},
				}
			},
			config = function(_, opts)
				if type(opts) == "table" and (opts.localSettings or opts.globalSettings) then
					vim.g.firenvim_config = opts
				end
				vim.opt.wrap = true
				-- wrap on word boundaries
				vim.opt.linebreak = true
			end,

			keys = {
				{ "<esc><esc>", "<cmd>call firenvim#focus_page()<cr><cmd>:w<cr>", silent = true },
				{ "<leader>q", "<cmd>q!<CR>" },
				{ "<leader>wq", "<cmd>wq!<CR>" },

				{ "<M-{>", "{", mode="i" },
				{ "<M-}>", "}", mode="i" },
				{ "<M-[>", "[", mode="i" },
				{ "<M-]>", "]", mode="i" },
				{ "<M-Bar>", "|", mode="i" },
			},
		}),
	}
end

return spec
