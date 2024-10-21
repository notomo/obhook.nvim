local M = {}

local default_opts = {
  hooks = {
    before_index = function(_, _) end,
    after_index = function(_, _) end,

    before_newindex = function(_, _) end,
    after_newindex = function(_, _) end,

    before_call = function(_, _) end,
    after_call = function(_, _) end,
  },

  parent_key = "obhook_root",
}
function M.new(raw_opts)
  raw_opts = raw_opts or {}
  return vim.tbl_deep_extend("force", default_opts, raw_opts)
end

return M
