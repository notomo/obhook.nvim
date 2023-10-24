local M = {}

--- @class ObhookNewOption
--- @field parent_keys any[]? |ObhookContext|.keys initial value
--- @field hooks ObhookHooks? |ObhookHooks|

--- @class ObhookContext
--- @field keys any[] accessed table keys

--- @class ObhookHooks
--- @field before_index fun(ctx:ObhookContext,tbl:table,key:any)? called on before table access
--- @field after_index fun(ctx:ObhookContext,tbl:table,key:any,value:any)? called on after table access
--- @field before_call fun(ctx:ObhookContext,f:function,args:table)? called on before function call
--- @field after_call fun(ctx:ObhookContext,f:function,args:table,result:table)? called on after function call
--- @field before_newindex fun(ctx:ObhookContext,tbl:table,key:any,value:any)? called on before table assignment
--- @field after_newindex fun(ctx:ObhookContext,tbl:table,key:any,value:any)? called on after table assignment

--- Returns hookable table to replace with target.
--- @param target table|function: target to hook on before/after access
--- @param opts ObhookNewOption?: |ObhookNewOption|
--- @return table # hookable table
function M.new(target, opts)
  return require("obhook.core.hooked").new(target, opts)
end

--- Returns newindex string expression.
--- @param ctx ObhookContext: |ObhookContext|
--- @param tbl table: pass |ObhookHooks|.before_newindex or |ObhookHooks|.after_newindex 'tbl' argument
--- @param key any: pass |ObhookHooks|.before_newindex or |ObhookHooks|.after_newindex 'key' argument
--- @param value any: pass |ObhookHooks|.before_newindex or |ObhookHooks|.after_newindex 'value' argument
--- @return string # "tbl[key] = value"
function M.string_newindex(ctx, tbl, key, value)
  return require("obhook.core.string").from_newindex(ctx, tbl, key, value)
end

--- Returns call string expression.
--- @param ctx ObhookContext: |ObhookContext|
--- @param f function: pass |ObhookHooks|.before_call or |ObhookHooks|.after_call 'f' argument
--- @param args table: pass |ObhookHooks|.before_call or |ObhookHooks|.after_call 'args' argument
--- @return string # "keys.f(args)"
function M.string_call(ctx, f, args)
  return require("obhook.core.string").from_call(ctx, f, args)
end

return M
