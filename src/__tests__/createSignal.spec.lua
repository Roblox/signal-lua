--!strict
local Packages = script.Parent.Parent.Parent
local JestGlobals = require(Packages.Dev.JestGlobals)
local jest = JestGlobals.jest
local it = JestGlobals.it
local expect = JestGlobals.expect

local createSignal = require(script.Parent.Parent.createSignal)

it("should fire subscribers and disconnect them", function()
	local signal, fire = createSignal(nil :: any)

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

it("should handle multiple subscribers", function()
	local signal, fire = createSignal(nil :: any)

	local spyA, spyAFn = jest.fn()
	local spyB, spyBFn = jest.fn()

	local subscriptionA = signal:subscribe(spyAFn)
	local subscriptionB = signal:subscribe(spyBFn)

	expect(spyA).never.toHaveBeenCalled()
	expect(spyB).never.toHaveBeenCalled()

	fire({})
	fire(67)

	expect(spyA).toHaveBeenCalledTimes(2)
	expect(spyA).toHaveBeenNthCalledWith(1, {})
	expect(spyA).toHaveBeenNthCalledWith(2, 67)

	expect(spyB).toHaveBeenCalledTimes(2)
	expect(spyB).toHaveBeenNthCalledWith(1, {})
	expect(spyB).toHaveBeenNthCalledWith(2, 67)

	subscriptionA:unsubscribe()

	fire(67)
	fire({})

	expect(spyA).toBeCalledTimes(2)

	expect(spyB).toBeCalledTimes(4)
	expect(spyB).toHaveBeenNthCalledWith(3, 67)
	expect(spyB).toHaveBeenNthCalledWith(4, {})

	subscriptionB:unsubscribe()
end)

it("should stop firing a connection if disconnected mid-fire", function()
	local signal, fire = createSignal(nil :: any)

	-- In this test, we'll connect two listeners that each try to disconnect
	-- the other. Because the order of listeners firing isn't defined, we
	-- have to be careful to handle either case.

	local subscriptionA
	local subscriptionB

	local spyA, spyAFn = jest.fn(function()
		subscriptionB:unsubscribe()
	end)

	local spyB, spyBFn = jest.fn(function()
		subscriptionA:unsubscribe()
	end)

	subscriptionA = signal:subscribe(spyAFn)
	subscriptionB = signal:subscribe(spyBFn)

	fire("foo")

	expect(#spyA.mock.calls + #spyB.mock.calls).toBe(1)
end)

it("allows new subscriptions during firing, only updates them on subsequent fires", function()
	local signal, fire = createSignal(0)
	local innerSubscription
	local innerSub, innerSubFn = jest.fn()
	local outerSub, outerSubFn = jest.fn()
	local outerSubscription = signal:subscribe(function(value)
		outerSubFn(value)
		if not innerSubscription then
			innerSubscription = signal:subscribe(innerSubFn)
		end
	end)

	fire(1)
	expect(outerSub).toHaveBeenCalledTimes(1)
	expect(innerSub).toHaveBeenCalledTimes(0)

	fire(2)
	expect(outerSub).toHaveBeenCalledTimes(2)
	expect(innerSub).toHaveBeenCalledTimes(1)

	outerSubscription:unsubscribe()
	fire(3)
	expect(outerSub).toHaveBeenCalledTimes(2)
	expect(innerSub).toHaveBeenCalledTimes(2)

	expect(outerSub).toHaveBeenLastCalledWith(2)
	expect(innerSub).toHaveBeenLastCalledWith(3)

	innerSubscription:unsubscribe()
	fire(4)

	expect(outerSub).toHaveBeenCalledTimes(2)
	expect(innerSub).toHaveBeenCalledTimes(2)
end)
