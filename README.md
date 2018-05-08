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

# Version 4 - alpha 1

<p align="center">
    <a href="#features">Features</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#codable">Codable</a> &bull;
    <a href="#nscoding">NSCoding</a> &bull;
    <a href="#rawrepresentable">RawRepresentable</a> &bull;
    <a href="#default-values">Default values</a> &bull;
    <a href="#custom-types">Custom types</a> &bull;
    <a href="#installation">Installation</a>
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

The convenient dot syntax is only available if you define your keys by extending magic `DefaultsKeys` class. You can also just pass the `DefaultsKey` value in square brackets, or use a more traditional string-based API. How? Keep reading.

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

| Optional variant | Non-optional variant | Default value |
| ---------------- | -------------------- | ------------- |
| `String?`        | `String`             | `""`          |
| `Int?`           | `Int`                | `0`           |
| `Double?`        | `Double`             | `0.0`         |
| `Bool?`          | `Bool`               | `false`       |
| `Data?`          | `Data`               | `Data()`      |
| `Date?`          | n/a                  | n/a           |
| `URL?`           | n/a                  | n/a           |

and arrays:

| Array type | Optional variant |
| ---------- | ---------------- |
| `[String]` | `[String]?`      |
| `[Int]`    | `[Int]?`         |
| `[Double]` | `[Double]?`      |
| `[Bool]`   | `[Bool]?`        |
| `[Data]`   | `[Data]?`        |
| `[Date]`   | `[Date]?`        |
| `[URL]`    | `[URL]?`         |

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

#### Default values

Since version 4, you can support a default value for your key (arrays as well!):
```swift
let frog = DefaultsKey<FrogCodable>("frog", defaultValue: FrogCodable(name: "Froggy"))
let frogs = DefaultsKey<FrogCodable>("frogs", defaultValue: [FrogCodable(name: "Froggy")])
```

 _or_ you can specify a default value for the whole type using two protocols, `DefaultsDefaultValueType` for a single value default:
 ```swift
extension FrogCodable: DefaultsDefaultValueType {
    static let defaultValue: FrogCodable = FrogCodable(name: "Froggy")
}
 ```

 or `DefaultsDefaultArrayValueType` for an array of type default:
 ```swift
extension FrogCodable: DefaultsDefaultArrayValueType {
    static let defaultArrayValue: [FrogCodable] = []
}
 ```

And then you can create your keys without specyfing a `defaultValue` each time!
```swift
let frog = DefaultsKey<FrogCodable>("frog")
let frogs = DefaultsKey<FrogCodable>("frogs")
```

### Custom types

So let's say there is a type that is not supported yet (like `NSCoding`, `Codable` or `RawRepresentable` before) and you want to support it.
You can do it by specializing getters and setters of `DefaultsSerializable`. See this extension we have for the Foundation's `URL` type:
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

And if you feel there is a type that we could support this, don't hesitate and create an Issue, or better yet, make a Pull Request 😉 We're gonna try to help you as much as possible!

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

## Installation

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
