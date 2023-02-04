--!strict
local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local it = JestGlobals.it
local expect = JestGlobals.expect

local createReadableSignal = require(script.Parent.Parent.createReadableSignal)

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
