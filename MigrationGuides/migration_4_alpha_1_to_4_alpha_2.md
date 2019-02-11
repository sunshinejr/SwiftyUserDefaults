# Migration guide from 4.0.0-alpha.1 to 4.0.0-alpha.2

Because there was a long delay in releasing a new version, and some things had changed, here is a quick migration guide.

### Removed type-based default value types
Oh well it didn't end up being that useful and in result we got both: our code got a lot more complicated and we got [major bug](https://github.com/radex/SwiftyUserDefaults/issues/162) to fix.

Right now if you want to have a default value for your key, you need to specify it in the key _only_:
```swift
let key = DefaultsKey<String>("test1", defaultValue: "")
```

### Updated a way of introducing custom retrieving/saving the values from a type:
Now we use `DefaultsBridge`s of many kinds to specify how you get/set values and arrays of values. When you look at `DefaultsSerializable` protocol, it expects two properties in each type: `_defaults` and `_defaultsArray` which are of type `DefaultsBridge`.

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
