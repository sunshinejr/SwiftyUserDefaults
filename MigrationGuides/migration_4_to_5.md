# Migration guide from 4.x to 5.x

### Changes to `Defaults`
`Defaults` is now a global variable, a `DefaultsAdapter` object, not `UserDefaults` typealias as it was before. `DefaultsAdapter` is our new object that enables key path access or dynamic access instead of relying on the keys.
Meaning you will use:
```swift
Defaults[\.yourKey]

// or if you use Swift 5.1, you can also:
Defaults.yourKey
```

instead of
```swift
Defaults[.yourKey]
```

Additionally when you want to access your key without a keyPath, but with a `DefaultsKey` as an argument, you would use:
```swift
let key = DefaultsKey<String?>("userThemeName")
Defaults[key: key]
```

instead of
```swift
let key = DefaultsKey<String?>("userThemeName")
Defaults[key]
```

We had to do this because otherwise the compiler crashed and indexing never finished... Track this issue here: https://bugs.swift.org/browse/SR-11529

### Changes to `DefaultsKeys`
Now you can create your own key store and `DefaultsKeys` is a default object that conforms to `DefaultsKeyStore` and is passed to the global `Defaults`.

Meaning you will now use:
```swift
extension DefaultsKeys {
    var userThemeName: DefaultsKey<String?> { .init("userThemeName") }
}
```

instead of:
```swift
extension DefaultsKeys {
    static let userThemeName = DefaultsKey<String?>("userThemeName")
}
```

### Changes to `DefaultsBridge`
First of all, it's a struct, not a class anymore! So no more inheritance, it's now all about composition when reusing the bridge.

Secondly we removed the `isSerializable` property as well, so you can remove it. Now you need to always provide `deserialize()` method when implementing your own custom bridge.

If you want to look at the bridge composition example (when using other bridges), see `DefaultsOptionalBridge` in `Sources/DefaultsBridges.swift`.