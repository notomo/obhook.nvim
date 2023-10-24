local helper = require("obhook.test.helper")
local obhook = helper.require("obhook")

describe("obhook.new()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can hook index", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local hooked = obhook.new({ key = "value" }, {
      hooks = {
        before_index = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_index = function()
          called = called + 1
          after = called
        end,
      },
    })

    local got = hooked.key

    assert.is_same(before, 1)
    assert.is_same(after, 2)
    assert.is_same("value", got)
    assert.is_same({ keys = { "key" } }, used_ctx)
  end)

  it("can hook nested index", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local hooked = obhook.new({ key1 = { key2 = "value" } }, {
      hooks = {
        before_index = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_index = function()
          called = called + 1
          after = called
        end,
      },
    })

    local got = hooked.key1.key2

    assert.is_same(before, 3)
    assert.is_same(after, 4)
    assert.is_same("value", got)
    assert.is_same({ keys = { "key1", "key2" } }, used_ctx)
  end)

  it("can hook newindex simply", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local target = { key = "value1" }
    local hooked = obhook.new(target, {
      hooks = {
        before_newindex = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_newindex = function()
          called = called + 1
          after = called
        end,
      },
    })

    hooked.key = "value2"

    assert.is_same(before, 1)
    assert.is_same(after, 2)
    assert.is_same("value2", target.key)
    assert.is_same({ keys = { "key" } }, used_ctx)
  end)

  it("can hook newindex in nested index", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local target = { key1 = { key2 = "value1" } }
    local hooked = obhook.new(target, {
      hooks = {
        before_newindex = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_newindex = function()
          called = called + 1
          after = called
        end,
      },
    })

    hooked.key1.key2 = "value2"

    assert.is_same(before, 1)
    assert.is_same(after, 2)
    assert.is_same("value2", target.key1.key2)
    assert.is_same({ keys = { "key1", "key2" } }, used_ctx)
  end)

  it("can hook call simply", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local f = function(a)
      return "value1", a
    end
    local hooked = obhook.new(f, {
      hooks = {
        before_call = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_call = function()
          called = called + 1
          after = called
        end,
      },
    })

    local got1, got2 = hooked("value2")

    assert.is_same(before, 1)
    assert.is_same(after, 2)
    assert.is_same("value1", got1)
    assert.is_same("value2", got2)
    assert.is_same({ keys = {} }, used_ctx)
  end)

  it("can hook call in nested index", function()
    local called = 0
    local before = 0
    local after = 0
    local used_ctx

    local target = {
      key = {
        f = function()
          return "value1"
        end,
      },
    }
    local hooked = obhook.new(target, {
      hooks = {
        before_call = function(ctx)
          called = called + 1
          before = called
          used_ctx = ctx
        end,
        after_call = function()
          called = called + 1
          after = called
        end,
      },
    })

    local got = hooked.key.f()

    assert.is_same(before, 1)
    assert.is_same(after, 2)
    assert.is_same("value1", got)
    assert.is_same({ keys = { "key", "f" } }, used_ctx)
  end)
end)
