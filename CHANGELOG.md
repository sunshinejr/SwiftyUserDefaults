### Next

### 5.0.0 (2019-12-31)
* 🚀

### 5.0.0-beta.5 (2019-10-05)

* Removed Combine extensions for now. Due to problems with weak-linking the framework, it's too difficult to support it with ease using all package managers and also without breaking backwards-compatibility. Probably gonna introduce it once we only support Xcode 11. [@sunshinejr](https://github.com/sunshinejr)

### 5.0.0-beta.4 (2019-09-27)

* Fixed an issue with Xcode freezing, never-finishing indexing/building the project when we used `Defaults[\.keyPath]` in conditional statement. Unfortunately we had to add `key` label to `Defaults[key: DefaultsKey<String?>...]` where you wouldn't have to add the label to the subscript before. [@sunshinejr](https://github.com/sunshinejr)

### 5.0.0-beta.3 (2019-09-25)

* Fixed an issue with SPM integration - it no longer fetches testing libraries & doesn't create runtime crashes or Xcode Preview crashes anymore. [@sunshinejr](https://github.com/sunshinejr)
* Fixed an issue where Carthage users using Xcode 11 couldn't install SwiftyUserDefaults 5. We added weak-linking for the xcodeproj so you might need additional steps for Xcode 10 + Carthage + SwiftyUserDefaults 5.* users. [@sunshinejr](https://github.com/sunshinejr)

### 5.0.0-beta.2 (2019-09-09)

* Added extensions for `Combine`! If you can `import Combine` and use it, check the `publisher(for:)` method on `DefaultsAdapter`. [@sunshinejr](https://github.com/sunshinejr)

### 5.0.0-beta.1 (2019-09-05)

* Introduced `DefaultsAdapter` thats the main object for user defaults and the `Defaults` global variable. [@marty-suzuki](https://github.com/marty-suzuki)
* Thanks to `DefaultsAdapter`, if you are using Swift 5.1 you can use dyanmic member lookup! This allows you to use 
`Defaults.yourKey` instead of `Defaults[.yourKey]`. In case you are not using Swift 5.1, you would need to transition to `Defaults[\.yourKey]` instead of `Defaults[.yourKey]`. [@marty-suzuki](https://github.com/marty-suzuki)
* There is a new protocol, `DefaultsKeyStore` that `DefaultsKeys` conform to. This key store is then accepted by the `DefaultsAdapter` so you can have multiple key stores for multiple adapters! [@marty-suzuki](https://github.com/marty-suzuki)
* Unfortunately the above means that you need to declare your keys as a computed properties instead of static stored ones.[@marty-suzuki](https://github.com/marty-suzuki)
* `DefaultsBridge` is now a struct, not a class. You need to use composition instead of inheritance to compose them. [@Z-JaDe](https://github.com/Z-JaDe)
* `DefaultsBridge` changed a little bit, there is no `isSerialized` property anymore, if you create your own bridge you need to provide `deserialize()` method as well. [@Z-JaDe](https://github.com/Z-JaDe)
* Added `@SwiftyUserDefault` property wrapper for Swift 5.1 users! It uses key paths and has options to cache/observe your defaults as well. [@sunshinejr](https://github.com/sunshinejr)
* Updated project to recommended settings of Xcode 10.2. [@philippec-ls](https://github.com/philippec-ls)

### 4.0.0 (2019-04-26)

* Updated `DefaultsKey.defaultValue` access level to `public`. [@DivineDominion](https://github.com/DivineDominion)
* Updated accesslevel of all bridges to `open` from `public`. [@fredpi](https://github.com/fredpi )

### 4.0.0-beta.2 (2019-03-09)

* Regenerated the project as a potential fix to Carthage linking problems in beta 1. [@sunshinejr](https://github.com/sunshinejr)

### 4.0.0-beta.1 (2019-02-25)

* Added support for launch arguments/plist for `Bool`, `Double`, `Int`, `String` values. [@sunshinejr](https://github.com/sunshinejr)
* Added support for KVO! [DivineDominion](https://github.com/DivineDominion), [toshi0383](https://github.com/toshi0383), [@sunshinejr](https://github.com/sunshinejr)
* Brought back dictionary support for `[String: Any]`/`[String: String]` and corresponding array version of it `[[String: Any]]`/`[[String: String]]`. [@sunshinejr](https://github.com/sunshinejr)

### 4.0.0-alpha.3 (2019-02-19)

* Fixed a non-optional vs optional comparison bug ([#176](https://github.com/radex/SwiftyUserDefaults/issues/176)). [@z3bi](https://github.com/z3bi) and [@sunshinejr](https://github.com/sunshinejr)
* Fixed an invalid Info.plist error ([#173](https://github.com/radex/SwiftyUserDefaults/issues/173)). [@sunshinejr](https://github.com/sunshinejr)

### 4.0.0-alpha.2 (2019-02-18)

* Swift 4.2 support. [@sunshinejr](https://github.com/sunshinejr)
* Early Swift 5.0 support! [@sunshinejr](https://github.com/sunshinejr)
* Rewritten core. We use `DefaultsBridges` now to define getters/setters for given type. [@sunshinejr](https://github.com/sunshinejr)
* Fixed a bug where you couldn't extend non-final class like `NSColor`. [@sunshinejr](https://github.com/sunshinejr)
* Removed type-based default values. This means you need to use key-based defaultValue or use an optional `DefaultsKey` from now on. [@sunshinejr](https://github.com/sunshinejr)
* Improved CI infra: Swift 4.1/4.2/5.0 builds with CocoaPods/Carthage/SPM integration scripts. [@sunshinejr](https://github.com/sunshinejr)


### 4.0.0-alpha.1 (2018-05-08)

* Swift 4.1 support [@sunshinejr](https://github.com/sunshinejr)
* Added `Codable` support! [@sunshinejr](https://github.com/sunshinejr)
* Added generic subscripts support (better `DefaultsKey` init diagnostics and accessing `Defaults[.key]`) [@sunshinejr](https://github.com/sunshinejr)
* Added default values protocols (`DefaultsDefaultValueType`, `DefaultsDefaultArrayValueType`) - this means that you can extend any type with default value so you can create non-optional `DefaultsKey` afterwards! [@sunshinejr](https://github.com/sunshinejr)
* Added default values in `DefaultsKey`, e.g. `DefaultsKey<String>("test", defaultValue: "default value")` [@sunshinejr](https://github.com/sunshinejr)
* Added better support for custom types: using `DefaultsSerializable`, when your type implements `NSCoding`, `RawRepresentable` (enums as well) or `Codable`, you get default implementations for free! [@sunshinejr](https://github.com/sunshinejr)
* Added automatic array support for any type that is available to `SwiftyUserDefaults` (means custom with `DefaultsSerializable` as well!) [@sunshinejr](https://github.com/sunshinejr)
* Added Swift Package Manager support! [@sunshinejr](https://github.com/sunshinejr)
* Added `[URL]` built-in support! [@sunshinejr](https://github.com/sunshinejr)
* A lot of infrastructure changes (CI, project), around 350 tests to make sure all of the changes work properly! [@sunshinejr](https://github.com/sunshinejr)
* Removed legacy strings based API (`Defaults["test"]`), `Dictionary` and `Any` support (sorry, with all the changes in the library we had to, but you _probably_ can bring it back with `DefaultsSerializable` anyways 😅) [@sunshinejr](https://github.com/sunshinejr)

### 3.0.1 (2016-11-12)

* Fix for Swift Package Manager #114 @max-potapov

### 3.0.0 (2016-09-14)

This is the Swift 3 update version.

It contains no major changes in the library itself, however it does change some APIs because of Swift 3 requirements.

* Update documentation and README for Swift 3
* Updated for Swift 3 and Xcode 8 compatibility #91 @askari01
* Updated for Swift 3 beta 4 #102 @rinatkhanov
* Updated for Swift 3 beta 6 #106 @ldiqual

---

### 2.2.1 (2016-08-03)

* `NSUserDefaults.set()` is now public (useful for adding support for custom types) #85 @goktugyil
* Support for Xcode 8 (Swift 2.3) for Carthage users #100 @KevinVitale

### 2.2.0 (2016-04-10)

* Support for `archive()` and `unarchive()` on `RawRepresentable` types
* Improved documentation

### 2.1.3 (2016-03-02)

* Fix Carthage build
* Suppress deprecation warnings in tests

### 2.1.2 (2016-03-01)

* Fixed infinite loop bug
* Added Travis CI integration
* Added Swift Package Manager support

### 2.1.1 (2016-02-29)

* Documentation improvements

### 2.1.0 (2016-02-29)

* Added `removeAll()`
* Added tvOS and watchOS support
* Fixed error when linking SwiftyUserDefaults with app extension targets
* Minor tweaks and fixes

### 2.0.0 (2015-09-18)

* Introducing statically-typed keys
  * Define keys using `DefaultsKey`
  * Extend magic `DefaultsKeys` class to get access to `Defaults[.foo]` shortcut
  * Support for all basic types, both in optional and non-optional forms
  * Support for arrays of basic types, such as `[Double]` or `[String]?`
  * Support for basic `[String: AnyObject]` dictionaries
  * `hasKey()` and `remove()` for static keys
  * You can define support for static keys of custom `NSCoder`-compliant types
  * Support for `NSURL` in statically-typed keys
* [Carthage] Added OS X support

**Deprecations**

* `+=`, `++`, `?=` operators are now deprecated in favor of statically-typed keys

---

### 1.3.0 (2015-06-29)

* Added non-optional `Proxy` getters
  * string -> stringValue, etc.
  * non-optional support for all except NSObject and NSDate getters
* Fixed Carthage (Set iOS Deployment target to 8.0)
* Converted tests to XCTest

### 1.2.0 (2015-06-15)

* Carthage support

### 1.1.0 (2015-04-13)

* Swift 1.2 compatibility
* Fixed podspec

### 1.0.0 (2015-01-26)

* Initial release
* `Proxy` getters:
  * String, Int, Double, Bool
  * NSArray, NSDictionary
  * NSDate, NSData
  * NSNumber, NSObject
* subscript setter
* `hasKey()`
* `remove()`
* `?=`, `+=`, `++` operators on `Proxy`
* global `Defaults` shortcut
