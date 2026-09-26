local source = debug.getinfo(1, 'S').source
local test_file = vim.fs.normalize(source:sub(2))
local root = vim.fs.dirname(vim.fs.dirname(test_file))

vim.opt.rtp:prepend(root)
vim.cmd 'filetype on'

require 'config.options'
require 'config.autocmds'

assert(vim.wo.foldmethod == 'expr', 'expected expression-based folds')
assert(vim.wo.foldexpr == vim.treesitter.foldexpr, 'expected Tree-sitter fold expression')
vim.cmd.vnew()
assert(vim.wo.foldmethod == 'expr', 'expected expression-based folds in new windows')
assert(vim.wo.foldexpr == vim.treesitter.foldexpr, 'expected Tree-sitter fold expression in new windows')
vim.cmd.close()

local tmpdir = vim.fn.tempname()
vim.fn.mkdir(tmpdir, 'p')

local function edit(filename)
  vim.cmd.edit(vim.fn.fnameescape(filename))
end

local function write(filename)
  vim.fn.writefile({}, filename)
end

local env_file = vim.fs.joinpath(tmpdir, '.env.production')
write(env_file)
edit(env_file)
assert(vim.bo.filetype == 'dotenv', 'expected dotenv filetype')

local toml_file = vim.fs.joinpath(tmpdir, 'settings.toml')
write(toml_file)
edit(toml_file)
assert(vim.bo.filetype == 'toml', 'expected TOML filetype')

local lua_file = vim.fs.joinpath(tmpdir, 'main.lua')
write(lua_file)
edit(lua_file)
assert(not vim.wo.spell, 'spell should be disabled for Lua files')

local markdown_file = vim.fs.joinpath(tmpdir, 'notes.md')
write(markdown_file)
edit(markdown_file)
assert(vim.wo.spell, 'spell should be enabled for Markdown files')

vim.cmd.help 'help'
local q_map = vim.fn.maparg('q', 'n', false, true)
assert(q_map.desc == 'Quit buffer', 'expected an immediate q mapping for help')

vim.fn.delete(tmpdir, 'rf')
