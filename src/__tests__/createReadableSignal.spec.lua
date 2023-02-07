--!strict
--[[
	* Copyright (c) Roblox Corporation. All rights reserved.
	* Licensed under the MIT License (the "License");
	* you may not use this file except in compliance with the License.
	* You may obtain a copy of the License at
	*
	*     https://opensource.org/licenses/MIT
	*
	* Unless required by applicable law or agreed to in writing, software
	* distributed under the License is distributed on an "AS IS" BASIS,
	* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	* See the License for the specific language governing permissions and
	* limitations under the License.
]]
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
