# Migration guide from 3.x to 4.x

### Legacy APIs

We've removed the support for legacy APIs using `String` values as keys in favor of `DefaultsKey`.
So if you've used `SwiftyUserDefaults` similar to:

```swift
let value = Defaults["key"].intValue
```

You need to either migrate to using `DefaultsKey` (and get all benefits of statically typed keys):

```swift
let key = DefaultsKey<Int>("key")
let value = Defaults[key]
```

or use `UserDefaults` instead.

If you used `Any` as a type of the `DefaultsKey`, you also need to migrate to use a proper type instead.

### NSCoding, RawRepresentable and Custom Types

If you used custom types with SwiftyUserDefaults, fear no more: you still can use them!
Now, you don't need your own `subcript` so remove it and add `DefaultsSerializable` protocol to your type!

Example. Let's say you had a class `Froggy` that conformed to the `NSCoding` protocol and you had your own subscript:

```swift
final class Froggy: NSObject, NSCoding { ... }

extension UserDefaults {
    subscript(key: DefaultsKey<Froggy?>) -> NSColor? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
```

Replace it with the code below:

```swift
final class Froggy: NSObject, NSCoding, DefaultsSerializable { ... }
```

And that's it! You have free custom types if you implement `NSCoding`, `RawRepresentable`(e.g. enums as well) or `Codable`. 

And if you want to add your own custom type that we don't support yet, no worries! We've got your covered as well. We use `DefaultsBridge`s of many kinds to specify how you get/set values and arrays of values. When you look at `DefaultsSerializable` protocol, it expects two properties in each type: `_defaults` and `_defaultsArray` which are of type `DefaultsBridge`.

For instance, this is a bridge for single value data storing/retrieving:
```swift
public final class DefaultsDataBridge: DefaultsBridge<Data> {
    public override func save(key: String, value: Data?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Data? {
        return userDefaults.data(forKey: key)
    }
}
```

And for a simple case of storing/retrieving an array values:
```swift
public final class DefaultsArrayBridge<T: Collection>: DefaultsBridge<T> {
    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.array(forKey: key) as? T
    }
}
```

And now that we have both bridges for single values/arrays, we can extend `Data` so it's supported out of the box!
```swift
extension Data: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Data> { return DefaultsDataBridge() }
    public static var _defaultsArray: DefaultsBridge<[Data]> { return DefaultsArrayBridge() }
}
```

Take a look at our source code (or tests) to look at more examples or make an issue and we will try to help you out in need!