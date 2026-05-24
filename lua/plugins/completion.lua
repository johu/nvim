local gh = require('vim-pack').gh

vim.pack.add {
  { src = gh 'rafamadriz/friendly-snippets' },
  { src = gh 'saghen/blink.lib' },
  { src = gh 'saghen/blink.cmp' },
}

local gen_loader = require('mini.snippets').gen_loader

local function by_lang()
  local loaders = {}

  return function(context)
    local lang = (context or {}).lang
    if type(lang) ~= 'string' or lang == '' then
      return {}
    end

    local patterns = {
      lang .. '/**/*.json',
      lang .. '/**/*.lua',
      lang .. '/**/*.code-snippets',
      '**/' .. lang .. '.json',
      '**/' .. lang .. '.lua',
      '**/' .. lang .. '.code-snippets',
    }

    local snippets = {}
    for _, pattern in ipairs(patterns) do
      local loader = loaders[pattern]
      if loader == nil then
        loader = gen_loader.from_runtime(pattern)
        loaders[pattern] = loader
      end
      table.insert(snippets, loader(context))
    end

    return snippets
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Build blink.cmp after install/update',
  group = vim.api.nvim_create_augroup('blink-build', { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
      vim.notify('Building blink.cmp...', vim.log.levels.INFO)
      local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = ev.data.path }):wait()
      if obj.code == 0 then
        vim.notify('Building blink.cmp done', vim.log.levels.INFO)
      else
        vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
      end
    end
  end,
})

require('mini.snippets').setup {
  snippets = {
    gen_loader.from_runtime 'all.json',
    gen_loader.from_runtime 'all.lua',
    gen_loader.from_runtime 'all.code-snippets',
    gen_loader.from_runtime 'global.json',
    gen_loader.from_runtime 'global.lua',
    gen_loader.from_runtime 'global.code-snippets',
    by_lang(),
  },
  mappings = {
    expand = '',
    jump_next = '',
    jump_prev = '',
  },
}

local cmp = require 'blink.cmp'
cmp.build():wait(60000)
cmp.setup {
  keymap = {
    preset = 'enter',
    ['<C-y>'] = { 'select_and_accept' },
    ['<C-j>'] = { 'select_next', 'fallback' },
    ['<C-k>'] = { 'select_prev', 'fallback' },
  },
  appearance = {
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    menu = {
      auto_show = true,
      draw = {
        treesitter = { 'lsp' },
        columns = { { 'kind_icon', 'label', 'label_description', gap = 1 }, { 'kind' } },
      },
    },
  },
  cmdline = {
    completion = {
      ghost_text = { enabled = true },
    },
  },
  snippets = {
    preset = 'mini_snippets',
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  signature = { enabled = true },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}
