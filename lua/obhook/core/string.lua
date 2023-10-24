local M = {}

local vim = vim

function M.from_newindex(ctx, _, _, v)
  local left = table.concat(ctx.keys, ".")
  local right = vim.inspect(v, { newline = " ", indent = "" })
  return left .. " = " .. right
end

function M.from_call(ctx, _, packed_args)
  local function_name = table.concat(ctx.keys, ".")

  local args_str = vim.inspect({ vim.F.unpack_len(packed_args) }, { newline = " ", indent = "" })
  if vim.startswith(args_str, "{") then
    args_str = args_str:sub(2)
  end
  if vim.endswith(args_str, "}") then
    args_str = args_str:sub(1, #args_str - 1)
  end
  args_str = vim.trim(args_str)

  return ("%s(%s)"):format(function_name, args_str)
end

return M
