//
// SwiftyUserDefaults
//
// Copyright (c) 2015-2016 Radosław Pietruszewski
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

public extension NSUserDefaults {
    class Proxy {
        private let defaults: NSUserDefaults
        private let key: String
        
        private init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: Getters
        
        public var object: NSObject? {
            return defaults.objectForKey(key) as? NSObject
        }
        
        public var string: String? {
            return defaults.stringForKey(key)
        }
        
        public var array: NSArray? {
            return defaults.arrayForKey(key)
        }
        
        public var dictionary: NSDictionary? {
            return defaults.dictionaryForKey(key)
        }
        
        public var data: NSData? {
            return defaults.dataForKey(key)
        }
        
        public var date: NSDate? {
            return object as? NSDate
        }
        
        public var number: NSNumber? {
            return defaults.numberForKey(key)
        }
        
        public var int: Int? {
            return number?.integerValue
        }
        
        public var double: Double? {
            return number?.doubleValue
        }
        
        public var bool: Bool? {
            return number?.boolValue
        }
        
        // MARK: Non-Optional Getters
        
        public var stringValue: String {
            return string ?? ""
        }
        
        public var arrayValue: NSArray {
            return array ?? []
        }
        
        public var dictionaryValue: NSDictionary {
            return dictionary ?? NSDictionary()
        }
        
        public var dataValue: NSData {
            return data ?? NSData()
        }
        
        public var numberValue: NSNumber {
            return number ?? 0
        }
        
        public var intValue: Int {
            return int ?? 0
        }
        
        public var doubleValue: Double {
            return double ?? 0
        }
        
        public var boolValue: Bool {
            return bool ?? false
        }
    }
    
    /// `NSNumber` representation of a user default
    
    func numberForKey(key: String) -> NSNumber? {
        return objectForKey(key) as? NSNumber
    }
    
    /// Returns getter proxy for `key`
    
    public subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
    
    /// Sets value for `key`
    
    public subscript(key: String) -> Any? {
        get {
            // return untyped Proxy
            // (make sure we don't fall into infinite loop)
            let proxy: Proxy = self[key]
            return proxy
        }
        set {
            switch newValue {
            case let v as Int: setInteger(v, forKey: key)
            case let v as Double: setDouble(v, forKey: key)
            case let v as Bool: setBool(v, forKey: key)
            case let v as NSURL: setURL(v, forKey: key)
            case let v as NSObject: setObject(v, forKey: key)
            case nil: removeObjectForKey(key)
            default: assertionFailure("Invalid value type")
            }
        }
    }
    
    /// Returns `true` if `key` exists
    
    public func hasKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    
    /// Removes value for `key`
    
    public func remove(key: String) {
        removeObjectForKey(key)
    }
    
    /// Removes all keys and values from user defaults
    /// Use with caution!
    /// - Note: This method only removes keys on the receiver `NSUserDefaults` object.
    ///         System-defined keys will still be present afterwards.
    
    public func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObjectForKey(key)
        }
    }
}

/// Global shortcut for `NSUserDefaults.standardUserDefaults()`
///
/// **Pro-Tip:** If you want to use shared user defaults, just
///  redefine this global shortcut in your app target, like so:
///  ~~~
///  var Defaults = NSUserDefaults(suiteName: "com.my.app")!
///  ~~~

public let Defaults = NSUserDefaults.standardUserDefaults()

// MARK: - Static keys

/// Extend this class and add your user defaults keys as static constants
/// so you can use the shortcut dot notation (e.g. `Defaults[.yourKey]`)

public class DefaultsKeys {
    private init() {}
}

/// Base class for static user defaults keys. Specialize with value type
/// and pass key name to the initializer to create a key.

public class DefaultsKey<ValueType>: DefaultsKeys {
    // TODO: Can we use protocols to ensure ValueType is a compatible type?
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
    }
}

extension NSUserDefaults {
    func set<T>(key: DefaultsKey<T>, _ value: Any?) {
        self[key._key] = value
    }
}

extension NSUserDefaults {
    /// Returns `true` if `key` exists
    
    public func hasKey<T>(key: DefaultsKey<T>) -> Bool {
        return objectForKey(key._key) != nil
    }
    
    /// Removes value for `key`
    
    public func remove<T>(key: DefaultsKey<T>) {
        removeObjectForKey(key._key)
    }
}

// MARK: Subscripts for specific standard types

// TODO: Use generic subscripts when they become available

extension NSUserDefaults {
    public subscript(key: DefaultsKey<String?>) -> String? {
        get { return stringForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<String>) -> String {
        get { return stringForKey(key._key) ?? "" }
        set { set(key, newValue) }
    }
    public subscript(key: DefaultsKey<NSString?>) -> NSString? {
        get { return stringForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSString>) -> NSString {
        get { return stringForKey(key._key) ?? "" }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Int?>) -> Int? {
        get { return numberForKey(key._key)?.integerValue }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Int>) -> Int {
        get { return numberForKey(key._key)?.integerValue ?? 0 }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Double?>) -> Double? {
        get { return numberForKey(key._key)?.doubleValue }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Double>) -> Double {
        get { return numberForKey(key._key)?.doubleValue ?? 0.0 }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Bool?>) -> Bool? {
        get { return numberForKey(key._key)?.boolValue }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<Bool>) -> Bool {
        get { return numberForKey(key._key)?.boolValue ?? false }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<AnyObject?>) -> AnyObject? {
        get { return objectForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSObject?>) -> NSObject? {
        get { return objectForKey(key._key) as? NSObject }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSData?>) -> NSData? {
        get { return dataForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSData>) -> NSData {
        get { return dataForKey(key._key) ?? NSData() }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSDate?>) -> NSDate? {
        get { return objectForKey(key._key) as? NSDate }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSURL?>) -> NSURL? {
        get { return URLForKey(key._key) }
        set { set(key, newValue) }
    }
    
    // TODO: It would probably make sense to have support for statically typed dictionaries (e.g. [String: String])
    
    public subscript(key: DefaultsKey<[String: AnyObject]?>) -> [String: AnyObject]? {
        get { return dictionaryForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[String: AnyObject]>) -> [String: AnyObject] {
        get { return dictionaryForKey(key._key) ?? [:] }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSDictionary?>) -> NSDictionary? {
        get { return dictionaryForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSDictionary>) -> NSDictionary {
        get { return dictionaryForKey(key._key) ?? [:] }
        set { set(key, newValue) }
    }
}

// MARK: Static subscripts for array types

extension NSUserDefaults {
    public subscript(key: DefaultsKey<NSArray?>) -> NSArray? {
        get { return arrayForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<NSArray>) -> NSArray {
        get { return arrayForKey(key._key) ?? [] }
        set { set(key, newValue) }
    }

    public subscript(key: DefaultsKey<[AnyObject]?>) -> [AnyObject]? {
        get { return arrayForKey(key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[AnyObject]>) -> [AnyObject] {
        get { return arrayForKey(key._key) ?? [] }
        set { set(key, newValue) }
    }
}

// We need the <T: AnyObject> and <T: _ObjectiveCBridgeable> variants to
// suppress compiler warnings about NSArray not being convertible to [T]
// AnyObject is for NSData and NSDate, _ObjectiveCBridgeable is for value
// types bridge-able to Foundation types (String, Int, ...)

extension NSUserDefaults {
    public func getArray<T: _ObjectiveCBridgeable>(key: DefaultsKey<[T]>) -> [T] {
        return arrayForKey(key._key) as NSArray? as? [T] ?? []
    }
    
    public func getArray<T: _ObjectiveCBridgeable>(key: DefaultsKey<[T]?>) -> [T]? {
        return arrayForKey(key._key) as NSArray? as? [T]
    }
    
    public func getArray<T: AnyObject>(key: DefaultsKey<[T]>) -> [T] {
        return arrayForKey(key._key) as NSArray? as? [T] ?? []
    }
    
    public func getArray<T: AnyObject>(key: DefaultsKey<[T]?>) -> [T]? {
        return arrayForKey(key._key) as NSArray? as? [T]
    }
}

extension NSUserDefaults {
    public subscript(key: DefaultsKey<[String]?>) -> [String]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[String]>) -> [String] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Int]?>) -> [Int]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Int]>) -> [Int] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Double]?>) -> [Double]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Double]>) -> [Double] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Bool]?>) -> [Bool]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Bool]>) -> [Bool] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[NSData]?>) -> [NSData]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[NSData]>) -> [NSData] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[NSDate]?>) -> [NSDate]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[NSDate]>) -> [NSDate] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
}

// MARK: - Archiving custom types

// MARK: RawRepresentable

extension NSUserDefaults {
    // TODO: Ensure that T.RawValue is compatible
    public func archive<T: RawRepresentable>(key: DefaultsKey<T>, _ value: T) {
        set(key, value.rawValue)
    }
    
    public func archive<T: RawRepresentable>(key: DefaultsKey<T?>, _ value: T?) {
        if let value = value {
            set(key, value.rawValue)
        } else {
            remove(key)
        }
    }
    
    public func unarchive<T: RawRepresentable>(key: DefaultsKey<T?>) -> T? {
        return objectForKey(key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
    
    public func unarchive<T: RawRepresentable>(key: DefaultsKey<T>) -> T? {
        return objectForKey(key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
}

// MARK: NSCoding

extension NSUserDefaults {
    // TODO: Can we simplify this and ensure that T is NSCoding compliant?
    
    public func archive<T>(key: DefaultsKey<T>, _ value: T) {
        if let value: AnyObject = value as? AnyObject {
            set(key, NSKeyedArchiver.archivedDataWithRootObject(value))
        } else {
            assertionFailure("Invalid value type, needs to be a NSCoding-compliant type")
        }
    }
    
    public func archive<T>(key: DefaultsKey<T?>, _ value: T?) {
        if let value: AnyObject = value as? AnyObject {
            set(key, NSKeyedArchiver.archivedDataWithRootObject(value))
        } else if value == nil {
            remove(key)
        } else {
            assertionFailure("Invalid value type, needs to be a NSCoding-compliant type")
        }
    }
    
    public func unarchive<T>(key: DefaultsKey<T?>) -> T? {
        return dataForKey(key._key).flatMap { NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? T
    }
    
    public func unarchive<T>(key: DefaultsKey<T>) -> T? {
        return dataForKey(key._key).flatMap { NSKeyedUnarchiver.unarchiveObjectWithData($0) } as? T
    }
}

// MARK: - Deprecations

infix operator ?= {
    associativity right
    precedence 90
}

/// If key doesn't exist, sets its value to `expr`
/// Note: This isn't the same as `Defaults.registerDefaults`. This method saves the new value to disk, whereas `registerDefaults` only modifies the defaults in memory.
/// Note: If key already exists, the expression after ?= isn't evaluated

@available(*, deprecated=1, message="Please migrate to static keys and use this gist: https://gist.github.com/radex/68de9340b0da61d43e60")
public func ?= (proxy: NSUserDefaults.Proxy, @autoclosure expr: () -> Any) {
    if !proxy.defaults.hasKey(proxy.key) {
        proxy.defaults[proxy.key] = expr()
    }
}

/// Adds `b` to the key (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to `b`

@available(*, deprecated=1, message="Please migrate to static keys to use this.")
public func += (proxy: NSUserDefaults.Proxy, b: Int) {
    let a = proxy.defaults[proxy.key].intValue
    proxy.defaults[proxy.key] = a + b
}

@available(*, deprecated=1, message="Please migrate to static keys to use this.")
public func += (proxy: NSUserDefaults.Proxy, b: Double) {
    let a = proxy.defaults[proxy.key].doubleValue
    proxy.defaults[proxy.key] = a + b
}

/// Icrements key by one (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to 1

@available(*, deprecated=1, message="Please migrate to static keys to use this.")
public postfix func ++ (proxy: NSUserDefaults.Proxy) {
    proxy += 1
}
