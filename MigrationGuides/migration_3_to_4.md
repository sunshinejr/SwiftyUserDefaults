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

And that's it! You have free custom types if you implement `NSCoding`, `RawRepresentable`(e.g. enums as well) or `Codable`. If you want a default value for that type, add `DefaultsDefaultValueType` for a single-value-key and `DefaultsDefaultArrayValueType` for array-value-key:

```swift
final class Froggy: NSObject, NSCoding, DefaultsSerializable { ... }

extension Froggy: DefaultsDefaultValueType {
  static let defaultValue: Froggy = FrogCodable(name: "Froggy")
}

extension Froggy: DefaultsDefaultArrayValueType {
  static let defaultArrayValue: [Froggy] = []
}
```

And if you want to add your own custom type that we don't support yet, no worries! We've got your covered as well. Below is an example of how we've got implemented `URL` extension:

```swift
extension URL: DefaultsSerializable {
    public static func get(key: String, userDefaults: UserDefaults) -> URL? {
        return userDefaults.url(forKey: key)
    }

    public static func getArray(key: String, userDefaults: UserDefaults) -> [URL]? {
        return userDefaults.data(forKey: key).flatMap(NSKeyedUnarchiver.unarchiveObject) as? [URL]
    }

    public static func save(key: String, value: URL?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public static func saveArray(key: String, value: [URL], userDefaults: UserDefaults) {
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
}
```
