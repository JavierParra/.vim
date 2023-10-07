require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    'bash',
    'comment',
    'dockerfile',
    'go',
    'graphql',
    'html',
    'http',
    'javascript',
    'jsdoc',
    'json',
    'json5',
    'latex',
    'lua',
    'markdown',
    'php',
    'prisma',
    'query',
    'regex',
    'scss',
    'scheme',
    'sql',
    'swift',
    'tsx',
    'typescript',
    'vim'
  },
  highlight = {
    enable = true,              -- false will disable the whole extension
    custom_captures = {
    }
  },
  indent = {
    enable = true
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gv",
      node_incremental = "gin",
      node_decremental = "gdn",
      scope_incremental = "gis",
    }
  },
  additional_vim_regex_highlighting = false,
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
}
