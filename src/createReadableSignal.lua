--!strict
type Callback<T> = (T) -> ()
type InternalSubscription<T> = { callback: Callback<T>, unsubscribed: boolean }

export type Subscription = {
	unsubscribe: (self: Subscription) -> (),
}
export type ReadableSignal<T> = {
	subscribe: (self: ReadableSignal<T>, callback: Callback<T>) -> Subscription,
	getValue: (self: ReadableSignal<T>) -> T,
}
export type FireSignal<T> = (T) -> ()

local createSignal = require(script.Parent.createSignal)

local function createReadableSignal<T>(initialValue: T): (ReadableSignal<T>, FireSignal<T>)
	local innerSignal, innerFire = createSignal()

	local lastValue = initialValue

	local function subscribe(_self: ReadableSignal<T>, callback: Callback<T>): Subscription
		return innerSignal:subscribe(callback)
	end

	local function getValue(_self: ReadableSignal<T>): T
		return lastValue
	end

	local function fire(value: T)
		lastValue = value
		innerFire(value)
	end

	return {
		subscribe = subscribe,
		getValue = getValue,
	}, fire
end

return createReadableSignal
