--!strict
local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local it = JestGlobals.it
local expect = JestGlobals.expect

local createReadableSignal = require(script.Parent.Parent.createReadableSignal)

it("can be subscribed to and fired like a regular signal", function()
	local signal, fire = createReadableSignal(nil :: any)

	local spy, spyFn = jest.fn()
	local subscription = signal:subscribe(spyFn)

	expect(spy).never.toBeCalled()

	fire(1)
	fire({ foo = "bar" })
	fire("hello")

	expect(spy).toHaveBeenCalledTimes(3)
	expect(spy).toHaveBeenNthCalledWith(1, 1)
	expect(spy).toHaveBeenNthCalledWith(2, { foo = "bar" })
	expect(spy).toHaveBeenNthCalledWith(3, "hello")

	subscription:unsubscribe()

	fire(99)

	expect(spy).toHaveBeenCalledTimes(3)
end)

it("provides access to the value via getValue", function()
	local signal, fire = createReadableSignal(1)
	expect(signal:getValue()).toEqual(1)

	fire(2)
	expect(signal:getValue()).toEqual(2)

	fire(99)
	expect(signal:getValue()).toEqual(99)
end)

it("always returns the most-recently emitted value through getValue", function()
	local signal, fire = createReadableSignal("start")
	local subscriber, subscriberFn = jest.fn()
	local subscription = signal:subscribe(subscriberFn)

	fire("foo")
	expect(subscriber).toHaveBeenLastCalledWith("foo")
	expect(signal:getValue()).toEqual(subscriber.mock.calls[1][1])

	fire("bar")
	expect(subscriber).toHaveBeenLastCalledWith("bar")
	expect(signal:getValue()).toEqual(subscriber.mock.calls[2][1])

	subscription:unsubscribe()
	fire("baz")
	expect(signal:getValue()).toEqual("baz")
	expect(subscriber).toHaveBeenCalledTimes(2)
end)
