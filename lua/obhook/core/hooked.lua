local M = {}

local vim = vim

function M.new(target, raw_opts)
  local opts = require("obhook.core.option").new(raw_opts)
  local ctx = require("obhook.core.context").new(opts.parent_keys)
  return M._new(ctx, target, opts)
end

function M._new(parent_ctx, target, opts)
  local index
  local newindex
  if type(target) == "table" then
    index = function(_, k)
      local ctx = require("obhook.core.context").from(parent_ctx, k)

      opts.hooks.before_index(ctx, target, k)
      local v = target[k]
      opts.hooks.after_index(ctx, target, k, v)

      if type(v) == "table" or vim.is_callable(v) then
        return M._new(ctx, v, opts)
      end

      return v
    end

    newindex = function(_, k, v)
      local ctx = require("obhook.core.context").from(parent_ctx, k)

      opts.hooks.before_newindex(ctx, target, k, v)
      target[k] = v
      opts.hooks.after_newindex(ctx, target, k, v)
    end
  end

  local call
  if vim.is_callable(target) then
    call = function(_, ...)
      local packed_k = vim.F.pack_len(...)
      opts.hooks.before_call(parent_ctx, target, packed_k)
      local packed_v = vim.F.pack_len(target(...))
      opts.hooks.after_call(parent_ctx, target, packed_k, packed_v)

      return vim.F.unpack_len(packed_v)
    end
  end

  return setmetatable({}, {
    __index = index,
    __newindex = newindex,
    __call = call,
  })
end

return M
