--!strict
export type Callback<T> = (T) -> ()
export type Subscription = {
	unsubscribe: (self: Subscription) -> (),
}

export type Signal<T> = {
	subscribe: (self: Signal<T>, callback: Callback<T>) -> Subscription,
}
export type ReadableSignal<T> = {
	subscribe: (self: ReadableSignal<T>, callback: Callback<T>) -> Subscription,
	getValue: (self: ReadableSignal<T>) -> T,
}
export type FireSignal<T> = (T) -> ()

return {}
