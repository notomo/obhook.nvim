local M = {}

function M.new(keys)
  return {
    keys = keys,
  }
end

function M.from(parent_ctx, key)
  local keys = {}
  vim.list_extend(keys, parent_ctx.keys)
  table.insert(keys, key)
  return M.new(keys)
end

return M
