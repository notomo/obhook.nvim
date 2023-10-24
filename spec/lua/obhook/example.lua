local obhook = require("obhook")
local hooked_vim = obhook.new(vim, {
  hooks = {
    before_newindex = function(ctx, tbl, k, v)
      local str = obhook.string_newindex(ctx, tbl, k, v)
      vim.print(str) -- vim.opt.wrap = false
    end,
    before_call = function(ctx, f, args)
      local str = obhook.string_call(ctx, f, args)
      vim.print(str) -- vim.api.nvim_create_buf(false, true)
    end,
  },
  parent_keys = { "vim" },
})

local vim = hooked_vim
vim.opt.wrap = false
vim.api.nvim_create_buf(false, true)
