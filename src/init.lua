--!strict
local createSignal = require(script.createSignal)
local createReadableSignal = require(script.createReadableSignal)
local types = require(script.types)

export type Subscription = types.Subscription
export type Signal<T> = types.Signal<T>
export type ReadableSignal<T> = types.ReadableSignal<T>
export type FireSignal<T> = types.FireSignal<T>

return {
	createSignal = createSignal,
	createReadableSignal = createReadableSignal,
}
