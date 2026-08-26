# nvim config

Personal Neovim configuration. Plugins are managed by [lazy.nvim](https://lazy.folke.io),
which bootstraps itself on first launch — clone this repo into `~/.config/nvim`, open
`nvim`, and everything installs.

## Layout

- `init.vim` — entry point. Sets up the winbar and some legacy vimscript (autocmds,
  terminal behavior), then hands off to the lua config.
- `lua/config/` — core config: `options`, `keymaps`, `commands`, and `lazy` (plugin
  manager bootstrap).
- `lua/plugins/` — one file per plugin (or plugin area); `init.lua` holds the small
  specs that don't need their own file. lazy.nvim imports the whole directory.
- `lua/custom/` — home-grown modules: `bob` (checks the running nvim version against
  [bob](https://github.com/MordechaiHadad/bob)), `live_notify` (progress notifications),
  `markdown`, `path_utils`.
- `ftplugin/`, `after/` — filetype-specific settings.

## Highlights

- **LSP**: configured natively via `vim.lsp.config()` / `vim.lsp.enable()` in
  `lua/plugins/lsp.lua` (ts_ls, lua_ls, jsonls, eslint, biome, markdown_oxide).
  Server binaries are installed by mason: `lua/plugins/mason.lua` declares
  `ensure_installed` and syncs against it on startup — installing what's missing and
  uninstalling anything not listed.
- **Completion**: [blink.cmp](https://github.com/saghen/blink.cmp).
- **Formatting**: conform.nvim, format on save. JS/TS picks the formatter from the
  project's config files: oxfmt → biome → prettier fallback.
- **Linting**: nvim-lint, same idea — oxlint or biome depending on the project.
- **Colorscheme**: catppuccino (`lua/plugins/colors.lua`).
- **Firenvim**: embeds nvim in browser text areas; loads a trimmed plugin set when
  started by the browser.
- Local plugin development: lazy.nvim `dev.path` points at `~/Documents/neovim-plugins`,
  used by `JavierParra/nvim-breadcrumbs`.

## Updating plugins

`:Lazy update` (or `:Lazy restore` to sync to the committed lockfile). Plugin versions
are pinned in `lazy-lock.json`.

On a new machine, register the merge driver that keeps the local `lazy-lock.json` on
conflicting pulls (see `.gitattributes`):
`git config merge.ours.driver true`

## Legacy remnants

`install.sh`, `.gitmodules` (the `bundle/` pathogen era), `coc-settings.json`, and the
`dap-adapters/` submodule predate the current setup and aren't used by it.
