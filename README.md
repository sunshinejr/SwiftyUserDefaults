# SwiftyUserDefaults

SwiftyUserDefaults is a set of extensions to make the `NSUserDefaults` API cleaner, nicer, and at home with Swift's syntax.

Read [Swifty APIs: NSUserDefaults](http://radex.io/swift/nsuserdefaults/) for more information about this project.

### Fetching data

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

SwiftyUserDefaults always returns `nil` for non-existing values, also for numbers and booleans.

### Setting data

```swift
Defaults["color"] = "red"
Defaults["launchCount"] = 0
```

SwiftyUserDefaults infers the right type when setting values.

### Optional assignment

```swift
Defaults["color"]            // => nil
Defaults["color"] ?= "white" // => "white"
Defaults["color"] ?= "red"   // => "white"
```

Works like `||=` in other languages — sets value only if the left-hand side value is `nil`.

### Arithmetic

```swift
Defaults["launchCount"] += 1
Defaults["launchCount"]++
```

You can use the `+=` and `++` operators to easily work on integer values in the user defaults. If the key didn't exist before operation, the operators assume it was `0`.

### Existence

```swift
if !Defaults.hasKey("hotkey") {
    Defaults.remove("hotkeyOptions")
}
```

You can use the `hasKey` method to check for key's existence in the user defaults. `remove()` is an alias for `removeObjectForKey()`.

### Installation

The simplest way to install this library is to copy `Src/SwiftyUserDefaults.swift` to your project. There's no step two!

_Note: Using Xcode 6.2 or older? You'll find a Swift 1.1-compatible version on the [1.0.0 tag](https://github.com/radex/SwiftyUserDefaults/tree/1.0.0)_

#### CocoaPods

You can also install this library using CocoaPods. Just add this line to your Podfile:

```ruby
pod 'SwiftyUserDefaults'
```

Then import library module like so:

```swift
import SwiftyUserDefaults
```

Note that this requires CocoaPods 0.36 as well as iOS 8 or OS X 10.9+

### Contributing

If you have comments, complaints or ideas for improvements, feel free to open an issue or a pull request.

### Author and license

Radek Pietruszewski

* [github.com/radex](http://github.com/radex)
* [twitter.com/radexp](http://twitter.com/radexp)
* [radex.io](http://radex.io)
* this.is@radex.io

SwiftyUserDefaults is available under the MIT license. See the LICENSE file for more info.
