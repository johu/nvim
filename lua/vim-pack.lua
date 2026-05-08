local M = {}

-- Helper to return full github url for given 'user/repo'
---@param name string|string to get the github url for
function M.gh(name)
  return string.format('https://github.com/%s', name)
end

return M
