# SwiftyUserDefaults 2.0

**SwiftyUserDefaults** makes `NSUserDefaults` cleaner, nicer and easier to use in Swift. Its statically-typed API gives you extra safety and convenient compile-time checks for free.

Read [Swifty APIs: NSUserDefaults](http://radex.io/swift/nsuserdefaults/) and [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static) for more information about this project.

### Define your keys

To get the most out of SwiftyUserDefaults, we recommend defining your user defaults keys ahead of time:

```swift
let colorKey = DefaultsKey<String>("color")
```

Just create a `DefaultsKey` object, put the value type in square bracket and the key name in parentheses and you're good to go.

You can now use the global `Defaults` object:

```swift
Defaults[colorKey] = "red"
Defaults[colorKey] // => "red", typed as String
```

The compiler won't let you set a wrong value type, and fetching conveniently returns `String` — no need for manual casting or special accessors.

### Take shortcuts

For extra convenience, define your keys by extending `DefaultsKeys` and adding static properties:

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

You can easily modify value types (strings, numbers, array) in place, without extra steps or magic operators, as if you were working with a plain old dictionary:

```swift
// Modify value types in place
Defaults[.launchCount]++
Defaults[.volume] += 0.1
Defaults[.strings] += "… can easily be extended!"

// Use and modify typed arrays
Defaults[.libraries].append("SwiftyUserDefaults")
Defaults[.libraries][0] += " 2.0"

// Easily work with custom serialized types
Defaults[.color] = NSColor.whiteColor()
Defaults[.color]?.whiteComponent // => 1.0
```

### Supported types

SwiftyUserDefaults supports all of the standard `NSUserDefaults` types, like strings, numbers, booleans, arrays and dictionaries.

Here's a full table:

| Optional variant       | Non-optional variant  | Default value |
|------------------------|-----------------------|---------------|
| `String?`              | `String`              | `""`          |
| `Int?`                 | `Int`                 | `0`           |
| `Double?`              | `Double`              | `0.0`         |
| `Bool?`                | `Bool`                | `false`       |
| `NSData?`              | `NSData`              | `NSData()`    |
| `[AnyObject]?`         | `[AnyObject]`         | `[]`          |
| `[String: AnyObject]?` | `[String: AnyObject]` | `[:]`         |
| `NSDate?`              | n/a                   | n/a           |
| `NSURL?`               | n/a                   | n/a           |
| `AnyObject?`           | n/a                   | n/a           |
| `NSString?`            | `NSString`            | `""`          |
| `NSArray?`             | `NSArray`             | `[]`          |
| `NSDictionary?`        | `NSDictionary`        | `[:]`         |

You can mark a type as optional to get `nil` if the key doesn't exist. Otherwise, you'll get a default value that makes sense for a given type.

#### Typed arrays

Additionally, typed arrays are available for these types:

| Array type | Optional variant |
|------------|------------------|
| `[String]` | `[String]?`      |
| `[Int]`    | `[Int]?`         |
| `[Double]` | `[Double]?`      |
| `[Bool]`   | `[Bool]?`        |
| `[NSData]` | `[NSData]?`      |
| `[NSDate]` | `[NSDate]?`      |

### Custom types

You can easily store custom `NSCoding`-compliant types by extending `NSUserDefaults` with this stub subscript:

```swift
extension NSUserDefaults {
    subscript(key: DefaultsKey<NSColor?>) -> NSColor? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}
```

Just copy&paste this and change `NSColor` to your class name. If you want, you can also remove `?` marks and coalesce nils: `unarchive(key) ?? yourDefaultValue`.

Here's an example use:

```swift
extension DefaultsKeys {
    static let color = DefaultsKey<NSColor?>("color")
}

Defaults[.color] // => nil
Defaults[.color] = NSColor.whiteColor()
Defaults[.color] // => w 1.0, a 1.0
Defaults[.color]?.whiteComponent // => 1.0
```

### Existence

```swift
if !Defaults.hasKey(.hotkey) {
    Defaults.remove(.hotkeyOptions)
}
```

You can use the `hasKey` method to check for key's existence in the user defaults. `remove()` is an alias for `removeObjectForKey()`, that also works with `DefaultsKeys` shortcuts.

## Legacy stringly-typed API

There's also a more traditional string-based API available. This will be deprecated and removed in future versions of this library — it's recommended you use the new static keys API.

```swift
Defaults["color"].string            // returns String?
Defaults["launchCount"].int         // returns Int?
Defaults["chimeVolume"].double      // returns Double?
Defaults["loggingEnabled"].bool     // returns Bool?
Defaults["lastPaths"].array         // returns NSArray?
Defaults["credentials"].dictionary  // returns NSDictionary?
Defaults["hotkey"].data             // returns NSData?
Defaults["firstLaunchAt"].date      // returns NSDate?
Defaults["anything"].object         // returns NSObject?
Defaults["anything"].number         // returns NSNumber?
```

When you don't want to deal with the `nil` case, you can use these helpers that return a default value for non-existing defaults:

```swift
Defaults["color"].stringValue            // defaults to ""
Defaults["launchCount"].intValue         // defaults to 0
Defaults["chimeVolume"].doubleValue      // defaults to 0.0
Defaults["loggingEnabled"].boolValue     // defaults to false
Defaults["lastPaths"].arrayValue         // defaults to []
Defaults["credentials"].dictionaryValue  // defaults to [:]
Defaults["hotkey"].dataValue             // defaults to NSData()
```

## Installation

The simplest way to install this library is to copy `SwiftyUserDefaults/SwiftyUserDefaults.swift` to your project. There's no step two!

#### CocoaPods

You can also install this library using CocoaPods. Just add this line to your Podfile:

```ruby
pod 'SwiftyUserDefaults'
```

Then import library module like so:

```swift
import SwiftyUserDefaults
```

#### Carthage

Just add to your Cartfile:

```ruby
github "radex/SwiftyUserDefaults"
```

## More like this

If you like SwiftyUserDefaults, check out [SwiftyTimer](https://github.com/radex/SwiftyTimer), which applies the same swifty approach to `NSTimer`.

You might also be interested in my blog posts which explain the design process behind those libraries:
- [Swifty APIs: NSUserDefaults](http://radex.io/swift/nsuserdefaults/)
- [Statically-typed NSUserDefaults](http://radex.io/swift/nsuserdefaults/static)
- [Swifty APIs: NSTimer](http://radex.io/swift/nstimer/)
- [Swifty methods](http://radex.io/swift/methods/)

### Contributing

If you have comments, complaints or ideas for improvements, feel free to open an issue or a pull request. Or [ping me on Twitter](http://twitter.com/radexp).

### Author and license

Radek Pietruszewski

* [github.com/radex](http://github.com/radex)
* [twitter.com/radexp](http://twitter.com/radexp)
* [radex.io](http://radex.io)
* this.is@radex.io

SwiftyUserDefaults is available under the MIT license. See the LICENSE file for more info.
