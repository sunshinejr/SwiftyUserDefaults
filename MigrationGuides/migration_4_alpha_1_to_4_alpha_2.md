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

For instance, this is a bridge for single value data storing/retrieving using `NSKeyedArchiver`/`NSKeyedUnarchiver`:
```swift
public final class DefaultsKeyedArchiverBridge<T>: DefaultsBridge<T> {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return deserialize(data)
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }

        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }

    public override func isSerialized() -> Bool {
        return true
    }

    public override func deserialize(_ object: Any) -> T? {
        guard let data = object as? Data else { return nil }

        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
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

Now, if you want to create a custom type and want to use `DefaultsKeyedArchiverBridge`:
```swift
struct FrogCustomSerializable: DefaultsSerializable {

    static var _defaults: DefaultsBridge<FrogCustomSerializable> { return DefaultsKeyedArchiverBridge() }
    static var _defaultsArray: DefaultsBridge<[FrogCustomSerializable]> { return DefaultsKeyedArchiverBridge() }

    let name: String
}
```

You have to remember though, that these built-in bridges are for specific use cases and you probably will end up writing your own bridges:
```swift
final class DefaultsFrogBridge: DefaultsBridge<FrogCustomSerializable> {
    override func get(key: String, userDefaults: UserDefaults) -> FrogCustomSerializable? {
        let name = userDefaults.string(forKey: key)
        return name.map(FrogCustomSerializable.init)
    }

    override func save(key: String, value: FrogCustomSerializable?, userDefaults: UserDefaults) {
        userDefaults.set(value?.name, forKey: key)
    }

    public override func isSerialized() -> Bool {
        return true
    }

    public override func deserialize(_ object: Any) -> FrogCustomSerializable? {
        guard let name = object as? String else { return nil }

        return FrogCustomSerializable(name: name)
    }
}

final class DefaultsFrogArrayBridge: DefaultsBridge<[FrogCustomSerializable]> {
    override func get(key: String, userDefaults: UserDefaults) -> [FrogCustomSerializable]? {
        return userDefaults.array(forKey: key)?
            .compactMap { $0 as? String }
            .map(FrogCustomSerializable.init)
    }

    override func save(key: String, value: [FrogCustomSerializable]?, userDefaults: UserDefaults) {
        let values = value?.map { $0.name }
        userDefaults.set(values, forKey: key)
    }

    public override func isSerialized() -> Bool {
        return true
    }

    public override func deserialize(_ object: Any) -> [FrogCustomSerializable]? {
        guard let names = object as? [String] else { return nil }

        return names.map(FrogCustomSerializable.init)
    }
}
```

and then provide them in your custom type:
```swift
struct FrogCustomSerializable: DefaultsSerializable, Equatable {

    static var _defaults: DefaultsBridge<FrogCustomSerializable> { return DefaultsFrogBridge() }
    static var _defaultsArray: DefaultsBridge<[FrogCustomSerializable]> { return DefaultsFrogArrayBridge() }

    let name: String
}
```

But, you can also extend an existing type!
```swift
extension Data: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Data> { return DefaultsDataBridge() }
    public static var _defaultsArray: DefaultsBridge<[Data]> { return DefaultsArrayBridge() }
}
```

Also, take a look at our source code (or tests) to look at more examples or make an issue and we will try to help you out in need! 