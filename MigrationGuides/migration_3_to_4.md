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


### Removed default values for certain types

You might've used this syntax before:
```swift
let key = DefaultsKey<String>("test1") // this might be nil when you access it, and so we were using some default values in the past like empty string
```

These defaults were quite confusing for some people and we decided to remove it in version 4 (+ it was really heavy in terms of codebase spaghetti). Don't worry though, as you can still define your own default values in version 4.0:
```swift
let key = DefaultsKey<String>("test1", defaultValue: "")
```

Or might try to create some custom inits/factories. If you can't migrate in your use-case, please provide details and create an issue so we can help with that!

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

Or if you want to add your own custom type that we don't support yet, no worries! We've got your covered as well. We use `DefaultsBridge`s of many kinds to specify how you get/set values and arrays of values. When you look at `DefaultsSerializable` protocol, it expects two properties in each type: `_defaults` and `_defaultsArray` which are of type `DefaultsBridge`.

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