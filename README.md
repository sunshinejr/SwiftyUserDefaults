# SwiftyUserDefaults

![Platforms](https://img.shields.io/badge/platforms-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos-lightgrey.svg)
[![CI Status](https://api.travis-ci.org/radex/SwiftyUserDefaults.svg?branch=master)](https://travis-ci.org/radex/SwiftyUserDefaults)
[![CocoaPods](http://img.shields.io/cocoapods/v/SwiftyUserDefaults.svg)](https://cocoapods.org/pods/SwiftyUserDefaults)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](#carthage)
![Swift version](https://img.shields.io/badge/swift-4.1-orange.svg)

#### Modern Swift API for `NSUserDefaults`
###### SwiftyUserDefaults makes user defaults enjoyable to use by combining expressive Swifty API with the benefits of static typing. Define your keys in one place, use value types easily, and get extra safety and convenient compile-time checks for free.

Read [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static) for more information about this project.<br />
Read [documentation for stable version 3.0.1](https://github.com/radex/SwiftyUserDefaults/blob/14b629b035bf6355b46ece22c3851068a488a895/README.md)<br />
Read [migration guide from version 3.x to 4.x](MigrationGuides/migration_3_to_4.md)
Read [migration guide from version 4.0.0-alpha.1 to 4.0.0-alpha.2](MigrationGuides/migration_4_alpha_1_to_4_alpha_2.md)

# Version 4 - alpha 2

<p align="center">
    <a href="#features">Features</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#codable">Codable</a> &bull;
    <a href="#nscoding">NSCoding</a> &bull;
    <a href="#rawrepresentable">RawRepresentable</a> &bull;
    <a href="#extending-existing-types">Extending existing types</a> &bull;
    <a href="#custom-types">Custom types</a> &bull;
    <a href="#installation">Installation & Requirements</a>
</p>

## Features

**There's only two steps to using SwiftyUserDefaults:**

Step 1: Define your keys

```swift
extension DefaultsKeys {
    static let username = DefaultsKey<String?>("username")
    static let launchCount = DefaultsKey<Int>("launchCount")
}
```

Step 2: Just use it!

```swift
// Get and set user defaults easily
let username = Defaults[.username]
Defaults[.hotkeyEnabled] = true

// Modify value types in place
Defaults[.launchCount] += 1
Defaults[.volume] -= 0.1
Defaults[.strings] += "… can easily be extended!"

// Use and modify typed arrays
Defaults[.libraries].append("SwiftyUserDefaults")
Defaults[.libraries][0] += " 2.0"

// Easily work with custom serialized types
Defaults[.color] = NSColor.white
Defaults[.color]?.whiteComponent // => 1.0
```

The convenient dot syntax is only available if you define your keys by extending magic `DefaultsKeys` class. You can also just pass the `DefaultsKey` value in square brackets.

## Usage

### Define your keys

To get the most out of SwiftyUserDefaults, define your user defaults keys ahead of time:

```swift
let colorKey = DefaultsKey<String>("color")
```

Just create a `DefaultsKey` object, put the type of the value you want to store in angle brackets, the key name in parentheses, and you're good to go.

You can now use the `Defaults` shortcut to access those values:

```swift
Defaults[colorKey] = "red"
Defaults[colorKey] // => "red", typed as String
```

The compiler won't let you set a wrong value type, and fetching conveniently returns `String`.

### Take shortcuts

For extra convenience, define your keys by extending magic `DefaultsKeys` class and adding static properties:

```swift
extension DefaultsKeys {
    static let username = DefaultsKey<String?>("username")
    static let launchCount = DefaultsKey<Int>("launchCount")
}
```

And use the shortcut dot syntax:

```swift
Defaults[.username] = "joe"
Defaults[.launchCount]
```

### Just use it!

You can easily modify value types (strings, numbers, array) in place, as if you were working with a plain old dictionary:

```swift
// Modify value types in place
Defaults[.launchCount] += 1
Defaults[.volume] -= 0.1
Defaults[.strings] += "… can easily be extended!"

// Use and modify typed arrays
Defaults[.libraries].append("SwiftyUserDefaults")
Defaults[.libraries][0] += " 2.0"

// Easily work with custom serialized types
Defaults[.color] = NSColor.white
Defaults[.color]?.whiteComponent // => 1.0
```

### Supported types

SwiftyUserDefaults supports all of the standard `NSUserDefaults` types, like strings, numbers, booleans, arrays and dictionaries.

Here's a full table of built-in single value defaults:

| Single value     | Array                |
| ---------------- | -------------------- |
| `String`         | `[String]`           |
| `Int`            | `[Int]`              |
| `Double`         | `[Double]`           |
| `Bool`           | `[Bool]`             |
| `Data`           | `[Data]`             |
| `Date`           | `[Date]`             |
| `URL`            | `[URL]`              |

But that's not all!

#### Codable

Since version 4, `SwiftyUserDefaults` support `Codable`! Just add `DefaultsSerializable` type to your type, like:
```swift
final class FrogCodable: Codable, DefaultsSerializable {
    let name: String
 }
```

No implementation needed! By doing this you will get an option to specify an optional `DefaultsKey`:
```swift
let frog = DefaultsKey<FrogCodable?>("frog")
```

Additionally, you've got an array support for free:
```swift
let froggies = DefaultsKey<[FrogCodable]?>("froggies")
```

#### NSCoding

`NSCoding` was supported before version 4, but in this version we take the support on another level. No need for custom subscripts anymore!
Support your custom `NSCoding` type the same way as you can support `Codable` types: add `DefaultsSerializable` to your implemented protocols:
```
final class FrogSerializable: NSObject, NSCoding, DefaultsSerializable { ... }
```

No implementation needed as well! By doing this you will get an option to specify an optional `DefaultsKey`:
```swift
let frog = DefaultsKey<FrogSerializable?>("frog")
```

Additionally, you've got an array support also for free:
```swift
let froggies = DefaultsKey<[FrogSerializable]?>("froggies")
```

#### RawRepresentable

And the last but not least, `RawRepresentable` support! It's all the same situation like with `NSCoding` or with `Codable`, add one
little protocol to rule them all!
```swift
enum BestFroggiesEnum: String, DefaultsSerializable {
    case Andy
    case Dandy
}
```

No implementation needed as well! By doing this you will get an option to specify an optional `DefaultsKey`:
```swift
let frog = DefaultsKey<BestFroggiesEnum?>("frog")
```

Additionally, you've got an array support also for free:
```swift
let froggies = DefaultsKey<[BestFroggiesEnum]?>("froggies")
```

### Extending existing types

Let's say you want to extend a support `UIColor` or any other type that is `NSCoding`, `Codable` or `RawRepresentable`.
Extending it to be `SwiftyUserDefaults`-friendly should be as easy as:
```swift
extension UIColor: DefaultsSerializable {}
```

If it's not, we have two options:
a) It's a custom type that we don't know how to serialize, in this case [look below](#custom-types)
b) It's a bug and it should be supported, in this case please file an issue, please (and you could also use [custom types](#custom-types) method as a workaround before we fix it)

### Custom types

If you want to add your own custom type that we don't support yet, no worries! We've got your covered as well. We use `DefaultsBridge`s of many kinds to specify how you get/set values and arrays of values. When you look at `DefaultsSerializable` protocol, it expects two properties in each type: `_defaults` and `_defaultsArray` which are of type `DefaultsBridge`.

For instance, this is a bridge for single value data storing/retrieving using `NSKeyedArchiver`/`NSKeyedUnarchiver`:
```swift
public final class DefaultsKeyedArchiverBridge<T>: DefaultsBridge<T> {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.data(forKey: key).flatMap(NSKeyedUnarchiver.unarchiveObject) as? T
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
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

Also, take a look at our source code (or tests) to look at more examples or make an issue and we will try to help you out in need! And if you feel there is a type that we could support this, don't hesitate and create an Issue, or better yet, make a Pull Request 😉

### Remove all keys

To reset user defaults, use `removeAll` method.

```swift
Defaults.removeAll()
```

### Shared user defaults

If you're sharing your user defaults between different apps or an app and its extensions, you can use SwiftyUserDefaults by overriding the `Defaults` shortcut with your own. Just add in your app:

```swift
var Defaults = UserDefaults(suiteName: "com.my.app")!
```

## Installation & Requirements

#### Requirements
Swift version >= 4.1

#### CocoaPods

If you're using CocoaPods, just add this line to your Podfile:

```ruby
pod 'SwiftyUserDefaults', '4.0.0-alpha.1'
```

Install by running this command in your terminal:

```sh
pod install
```

Then import the library in all files where you use it:

```swift
import SwiftyUserDefaults
```

#### Carthage

Just add to your Cartfile:

```ruby
github "radex/SwiftyUserDefaults" "4.0.0-alpha.1"
```

#### Swift Package Manager

Just add to your `Package.swift` under dependencies:
```swift
let package = Package(
    name: "MyPackage",
    products: [...],
    dependencies: [
        .package(url: "https://github.com/radex/SwiftyUserDefaults.git", .exact("4.0.0-alpha.1")),
    ],
    targets: [...]
)
```

## More like this

If you like SwiftyUserDefaults, check out [SwiftyTimer](https://github.com/radex/SwiftyTimer), which applies the same swifty approach to `NSTimer`.

You might also be interested in my blog posts which explain the design process behind those libraries:
- [Swifty APIs: NSUserDefaults](http://radex.io/swift/nsuserdefaults/)
- [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static)
- [Swifty APIs: NSTimer](http://radex.io/swift/nstimer/)
- [Swifty methods](http://radex.io/swift/methods/)

### Contributing

If you have comments, complaints or ideas for improvements, feel free to open an issue or a pull request.

### Author and license

*Maintainer:* Łukasz Mróz
* [github.com/sunshinejr](http://github.com/sunshinejr)
* [twitter.com/thesunshinejr](http://twitter.com/thesunshinejr)
* [sunshinejr.com](https://sunshinejr.com)

*Created by:* Radek Pietruszewski

* [github.com/radex](http://github.com/radex)
* [twitter.com/radexp](http://twitter.com/radexp)
* [radex.io](http://radex.io)
* this.is@radex.io

SwiftyUserDefaults is available under the MIT license. See the LICENSE file for more info.
