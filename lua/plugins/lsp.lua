local gh = require('vim-pack').gh

vim.pack.add {
  { src = gh 'neovim/nvim-lspconfig' },
  { src = gh 'mason-org/mason.nvim' },
  { src = gh 'mason-org/mason-lspconfig.nvim' },
  { src = gh 'WhoIsSethDaniel/mason-tool-installer.nvim' },
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
  lua_ls = {
    mason = 'lua-language-server',
  },
  marksman = {
    mason = 'marksman',
  },
  termux_language_server = {
    mason = 'termux-language-server',
    filetypes = { 'ebuild' },
    -- generic Bash checks do not understand Gentoo ebuild semantics
    handlers = {
      ['textDocument/publishDiagnostics'] = function() end,
    },
  },
}

local function extend_server_config(server_name, server)
  local ok, extra = pcall(require, 'lsp.' .. server_name)
  if not ok then
    return server
  end

  return vim.tbl_deep_extend('force', server, extra)
end

local ensure_installed = vim.tbl_map(function(server)
  return server.mason
end, vim.tbl_values(servers))

vim.list_extend(ensure_installed, {
  'shellcheck',
  'shfmt',
  'stylua',
  'markdownlint-cli2',
  'markdown-toc',
  'prettier',
})

require('mason').setup {}
require('mason-lspconfig').setup()
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

vim.lsp.config('*', {
  capabilities = capabilities,
})

for server_name, server in pairs(servers) do
  local config = vim.deepcopy(extend_server_config(server_name, server))
  config.mason = nil
  vim.lsp.config(server_name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

local lsp_attach_group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true })
local lsp_highlight_group = vim.api.nvim_create_augroup('config-lsp-highlight', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_attach_group,
  callback = function(event)
    local fzf = require 'fzf-lua'
    local client = vim.lsp.get_client_by_id(event.data.client_id)

    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func, {
        buffer = event.buf,
        desc = 'LSP: ' .. desc,
      })
    end

    map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', fzf.lsp_references, '[G]oto [R]eferences')
    map('gri', fzf.lsp_implementations, '[G]oto [I]mplementation')
    map('grd', fzf.lsp_definitions, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gO', fzf.lsp_document_symbols, 'Open Document Symbols')
    map('gW', fzf.lsp_live_workspace_symbols, 'Open Workspace Symbols')
    map('grt', fzf.lsp_typedefs, '[G]oto [T]ype Definition')

    local supports_document_highlight = client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    if supports_document_highlight and not vim.b[event.buf].lsp_document_highlight then
      vim.b[event.buf].lsp_document_highlight = true

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = lsp_highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = lsp_highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = lsp_attach_group,
  callback = function(event)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      local method = vim.lsp.protocol.Methods.textDocument_documentHighlight
      local has_highlight_client = vim.iter(vim.lsp.get_clients { bufnr = event.buf }):any(function(client)
        return client:supports_method(method, event.buf)
      end)
      if has_highlight_client then
        return
      end

      vim.lsp.util.buf_clear_references(event.buf)
      vim.api.nvim_clear_autocmds { group = lsp_highlight_group, buffer = event.buf }
      vim.b[event.buf].lsp_document_highlight = nil
    end)
  end,
})
