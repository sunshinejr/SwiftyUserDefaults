### master

- Fixed error when linking SwiftyUserDefaults with app extension targets
- [Carthage] Added tvOS support
- [Carthage] Added watchOS support
- [CocoaPods] Added tvOS support
- Minor tweaks and fixes

### 2.0.0 (18 September 2015)

- Introducing statically-typed keys
    * Define keys using `DefaultsKey`
    * Extend magic `DefaultsKeys` class to get access to `Defaults[.foo]` shortcut
    * Support for all basic types, both in optional and non-optional forms
    * Support for arrays of basic types, such as `[Double]` or `[String]?`
    * Support for basic `[String: AnyObject]` dictionaries
    * `hasKey()` and `remove()` for static keys
    * You can define support for static keys of custom `NSCoder`-compliant types
    * Support for `NSURL` in statically-typed keys
- [Carthage] Added OS X support

**Deprecations**

- `+=`, `++`, `?=` operators are now deprecated in favor of statically-typed keys

* * *

### 1.3.0 (29 June 2015)

- Added non-optional `Proxy` getters
    * string -> stringValue, etc.
    * non-optional support for all except NSObject and NSDate getters
- Fixed Carthage (Set iOS Deployment target to 8.0)
- Converted tests to XCTest

### 1.2.0 (15 June 2015)

- Carthage support

### 1.1.0 (13 April 2015)

- Swift 1.2 compatibility
- Fixed podspec

### 1.0.0 (26 January 2015)

- Initial release
- `Proxy` getters:
    * String, Int, Double, Bool
    * NSArray, NSDictionary
    * NSDate, NSData
    * NSNumber, NSObject
- subscript setter
- `hasKey()`
- `remove()`
- `?=`, `+=`, `++` operators on `Proxy`
- global `Defaults` shortcut
