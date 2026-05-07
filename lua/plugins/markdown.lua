vim.pack.add {
  { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
  { src = 'https://github.com/iamcco/markdown-preview.nvim' },
}

require('render-markdown').setup {}
vim.cmd [[do FileType]]

local function toggle_markdown_preview()
  vim.fn['mkdp#util#install_sync'](1)
  vim.fn['mkdp#util#toggle_preview']()
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('config-markdown-preview-map', { clear = true }),
  pattern = 'markdown',
  callback = function(event)
    vim.keymap.set('n', '<leader>cp', toggle_markdown_preview, {
      buffer = event.buf,
      desc = 'Markdown Preview',
    })
  end,
})
