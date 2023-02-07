## Types

The signal objects have the following types:
```lua
type Signal<T> = {
    subscribe: (self: Signal<T>, callback: (T) -> ()) -> Subscription,
}

type ReadableSignal<T> = {
    subscribe: (self: ReadableSignal<T>, callback: (T) -> ()) -> Subscription,
    getValue: (self: ReadableSignal) -> T,
}
```

The `Subscription` object returned from the `subscribe` method of each Signal type has the following type:
```lua
type Subscription = {
    unsubscribe: (self: Subscription) -> ()
}
```

Finally, the signal creation functions each return a callback along with the signal that can be used to fire it with new values:
```lua
type FireSignal<T> = (T) -> ()
```

## API

### createSignal
```
createSignal<T>() -> Signal<T>, FireSignal<T>
```

Returns a `Signal<T>` object (with a `subscribe` method) and a function to fire the signal, publishing new values to all subscribers.

### createReadableSignal
```
createReadableSignal<T>(initialValue: T) -> ReadableSignal<T>, FireSignal<T>

```

Returns a `ReadableSignal<T>` object and a function to fire the signal. This is similar to a `Signal<T>`, but it accepts an initial value and includes a `getValue()` method that returns the last value fired (or the initial value).

This behaves more like a subscribable state container that tracks a persistent value and updates subscribers when it changes. It can be useful when subscribers need to know the most recent value at the time that they subscribe (rather than waiting till the signal next fires).
