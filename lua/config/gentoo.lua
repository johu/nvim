local namespace = vim.api.nvim_create_namespace 'config-pkgcheck'
local generations = {}

local severity = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
  style = vim.diagnostic.severity.INFO,
  info = vim.diagnostic.severity.INFO,
}

local function repo_root(path)
  return vim.fs.root(path, { 'profiles/repo_name', 'metadata/layout.conf', '.git' })
end

local function package_atom(root, path)
  local relative = vim.fs.relpath(root, path)
  if not relative then
    return
  end

  local category, package = relative:match '^([^/]+)/([^/]+)/.+%.ebuild$'
  if not category or not package then
    return
  end

  return category .. '/' .. package
end

local function parse_reports(output)
  local diagnostics = {}

  for report in vim.gsplit(output, '\n', { trimempty = true }) do
    local _, line, level, message = report:match '^([^:]+):(%d+):([^:]+):(.*)$'
    if line and level and message then
      table.insert(diagnostics, {
        lnum = math.max(tonumber(line) - 1, 0),
        severity = severity[level:lower()] or vim.diagnostic.severity.WARN,
        source = 'pkgcheck',
        message = message,
      })
    end
  end

  return diagnostics
end

local function check(event)
  local path = vim.api.nvim_buf_get_name(event.buf)
  if vim.fn.fnamemodify(path, ':e') ~= 'ebuild' then
    return
  end

  local root = repo_root(path)
  local atom = root and package_atom(root, path)
  if not atom or vim.fn.executable 'pkgcheck' == 0 then
    return
  end

  generations[event.buf] = (generations[event.buf] or 0) + 1
  local generation = generations[event.buf]
  vim.diagnostic.reset(namespace, event.buf)

  vim.system({ 'pkgcheck', 'scan', '--repo', root, '--reporter', 'FlycheckReporter', atom }, {
    cwd = root,
    text = true,
  }, function(result)
    if result.code ~= 0 and result.code ~= 1 then
      vim.schedule(function()
        vim.notify('pkgcheck failed: ' .. result.stderr, vim.log.levels.WARN)
      end)
      return
    end

    local diagnostics = parse_reports(result.stdout)
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(event.buf) and generations[event.buf] == generation then
        vim.diagnostic.set(namespace, event.buf, diagnostics)
      end
    end)
  end)
end

vim.api.nvim_create_autocmd('BufWritePost', {
  group = vim.api.nvim_create_augroup('config-pkgcheck', { clear = true }),
  pattern = '*.ebuild',
  callback = check,
  desc = 'Check saved ebuilds with pkgcheck',
})
