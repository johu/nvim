local packages = vim.pack.get(nil, { info = false })
local active_packages = {}

for _, package in ipairs(packages) do
  active_packages[package.spec.name] = package.active
end

for _, name in ipairs { 'mini.nvim', 'blink.cmp', 'conform.nvim', 'fzf-lua', 'nvim-lspconfig' } do
  assert(active_packages[name], ('expected active package: %s'):format(name))
end

local pair_open = vim.fn.maparg('(', 'i', false, true)
local pair_close = vim.fn.maparg(')', 'i', false, true)
assert(pair_open.rhs:match 'MiniPairs.open', 'expected MiniPairs opener mapping')
assert(pair_close.rhs:match 'MiniPairs.close', 'expected MiniPairs closer mapping')

local lua_ls = vim.lsp.config.lua_ls
assert(type(lua_ls) == 'table', 'expected lua_ls configuration')
assert(lua_ls.capabilities, 'expected completion capabilities for lua_ls')
assert(vim.fn.exists ':PackUpdate' == 2, 'expected PackUpdate command')
