vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
}

require('nvim-treesitter').setup {
  autotag = { enable = true },
}
require('nvim-ts-autotag').setup {}

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    pcall(vim.treesitter.start)
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

local ensure_installed = {
  'bash',
  'c',
  'cmake',
  'cpp',
  'css',
  'desktop',
  'devicetree',
  'diff',
  'dockerfile',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'go',
  'gomod',
  'gosum',
  'gpg',
  'html',
  'hyprlang',
  'ini',
  'java',
  'javascript',
  'json',
  'jq',
  'lua',
  'markdown',
  'markdown_inline',
  'ninja',
  'passwd',
  'properties',
  'python',
  'query',
  'ssh_config',
  'tmux',
  'toml',
  'tsx',
  'typescript',
  'udev',
  'vim',
  'vimdoc',
  'xml',
  'yaml',
  'zig',
}

local installed = require('nvim-treesitter.config').get_installed()

local to_install = vim
  .iter(ensure_installed)
  :filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end)
  :totable()

require('nvim-treesitter').install(to_install)
