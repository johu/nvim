local gh = require('vim-pack').gh
local map = vim.keymap.set
local uv = vim.uv

local function register_harpoon_plenary_compat()
  -- Harpoon 2 still uses a tiny plenary surface for persistence and debug
  -- reloads. Reimplement just what it needs so this config can drop plenary.
  package.preload['plenary.path'] = function()
    local Path = {}
    Path.__index = Path

    function Path:new(path)
      return setmetatable({ filename = vim.fs.normalize(path) }, self)
    end

    function Path:exists()
      return uv.fs_stat(self.filename) ~= nil
    end

    function Path:mkdir()
      vim.fn.mkdir(self.filename, 'p')
    end

    function Path:make_relative(root)
      if root == nil or root == '' then
        return self.filename
      end

      return vim.fs.relpath(root, self.filename) or self.filename
    end

    function Path:read()
      local fd = assert(uv.fs_open(self.filename, 'r', 438))
      local stat = assert(uv.fs_fstat(fd))
      local data = stat.size > 0 and assert(uv.fs_read(fd, stat.size, 0)) or ''
      assert(uv.fs_close(fd))
      return data
    end

    function Path:write(data, flag)
      if flag ~= 'w' then
        error('plenary.path compatibility only supports write mode')
      end

      local parent = vim.fs.dirname(self.filename)
      if parent then
        vim.fn.mkdir(parent, 'p')
      end

      local fd = assert(uv.fs_open(self.filename, 'w', 420))
      assert(uv.fs_write(fd, data, 0))
      assert(uv.fs_close(fd))
    end

    return Path
  end

  package.preload['plenary.reload'] = function()
    local M = {}

    function M.reload_module(prefix)
      for name in pairs(package.loaded) do
        if name == prefix or vim.startswith(name, prefix .. '.') then
          package.loaded[name] = nil
        end
      end
    end

    return M
  end
end

vim.pack.add {
  { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
  { src = gh 'stevearc/oil.nvim' },
  { src = gh 'ibhagwan/fzf-lua' },
}

register_harpoon_plenary_compat()

local harpoon = require 'harpoon'
harpoon:setup {
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
}

require('oil').setup {
  view_options = {
    show_hidden = true,
  },
}

require('fzf-lua').setup {}

map('n', '<leader>H', function()
  harpoon:list():add()
end, { desc = 'Harpoon File' })

map('n', '<leader>h', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon Quick Menu' })

for index, shortcut in ipairs { 'h', 'j', 'k', 'l' } do
  map('n', '<A-' .. shortcut .. '>', function()
    harpoon:list():select(index)
  end, { desc = 'Harpoon to File ' .. index })
end

map('n', '-', require('oil').open, { desc = 'Open file explorer' })

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config-fzf-terminal-keys', { clear = true }),
  pattern = 'fzf',
  callback = function(event)
    map('t', '<c-j>', '<c-j>', { buffer = event.buf, nowait = true })
    map('t', '<c-k>', '<c-k>', { buffer = event.buf, nowait = true })
  end,
})

local fzf = require 'fzf-lua'

map('n', '<leader>fb', function()
  fzf.buffers()
end, { desc = 'Buffers' })
map('n', '<leader>ff', function()
  fzf.files()
end, { desc = 'Files' })
map('n', '<leader>fg', function()
  fzf.git_files()
end, { desc = 'Git Files' })
map('n', '<leader>fk', function()
  fzf.keymaps()
end, { desc = 'Keymaps' })
map('n', '<leader>fh', function()
  fzf.helptags()
end, { desc = 'Help' })
map('n', '<leader>fr', function()
  fzf.oldfiles()
end, { desc = 'Recent' })
map('n', '<leader>fu', function()
  fzf.builtin()
end, { desc = 'Builtin' })
map('n', '<leader>sb', function()
  fzf.lgrep_curbuf()
end, { desc = 'Buffer' })
map('n', '<leader>sg', function()
  fzf.live_grep()
end, { desc = 'Grep' })
map('n', '<leader>sw', function()
  fzf.grep_cword()
end, { desc = 'Current Word' })
map('n', '<leader>sW', function()
  fzf.grep_cWORD()
end, { desc = 'Current WORD' })
map('n', '<leader>sd', function()
  fzf.diagnostics_document()
end, { desc = 'Diagnostics' })
map('n', '<leader>sD', function()
  fzf.diagnostics_workspace()
end, { desc = 'Diagnostics (Workspace)' })
map('n', '<leader>sR', function()
  fzf.resume()
end, { desc = 'Resume' })
map('n', '<leader>gc', function()
  fzf.git_commits()
end, { desc = 'Commits' })
map('n', '<leader>gs', function()
  fzf.git_status()
end, { desc = 'Status' })
map('n', '<leader>ec', function()
  fzf.files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Neovim Config' })
map('n', '<leader>ep', function()
  fzf.files { cwd = vim.fs.joinpath(vim.fn.stdpath 'data', 'site', 'pack', 'core', 'start') }
end, { desc = 'Packages' })
map('n', '<leader>/', function()
  fzf.live_grep()
end, { desc = '[/] Grep' })
map('n', '<leader>,', function()
  fzf.buffers { sort_mru = true, sort_lastused = true }
end, { desc = 'Switch Buffer' })
map('n', '<leader>:', function()
  fzf.command_history()
end, { desc = 'Command History' })
map('n', '<leader><leader>', function()
  fzf.files()
end, { desc = 'Find Files' })

map('n', '<leader>st', function()
  fzf.live_grep { search = 'TODO|FIX|FIXME' }
end, { desc = 'Todo/Fix/Fixme' })
