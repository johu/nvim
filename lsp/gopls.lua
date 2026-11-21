---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      -- extra analyzers beyond `go vet`
      staticcheck = true,
      -- insert argument placeholders when completing functions
      usePlaceholders = true,
      hints = {
        parameterNames = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
      },
    },
  },
}
