-- Progress messages (LSP, ...) go to the floating message window instead of
-- the cmdline, so they do not fight with typed commands.
require('vim._core.ui2').enable { msg = { targets = { progress = 'msg' } } }
require 'config.progress'
require 'config.dashboard'
require 'config.statusline'
require 'config.tabline'
