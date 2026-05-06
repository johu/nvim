vim.pack.add {
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
}

local capabilities = require('blink.cmp').get_lsp_capabilities()

local servers = {
  lua_ls = {
    mason = 'lua-language-server',
  },
  marksman = {
    mason = 'marksman',
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
  root_markers = { '.git' },
})

for server_name, server in pairs(servers) do
  local config = vim.deepcopy(extend_server_config(server_name, server))
  config.mason = nil
  vim.lsp.config(server_name, config)
end

vim.lsp.enable(vim.tbl_keys(servers))

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('config-lsp-attach', { clear = true }),
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

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_group = vim.api.nvim_create_augroup('config-lsp-highlight', { clear = false })

      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('config-lsp-detach', { clear = true }),
        callback = function(detach_event)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds {
            group = 'config-lsp-highlight',
            buffer = detach_event.buf,
          }
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})
