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

/// Global shortcut for `UserDefaults.standard`
///
/// **Pro-Tip:** If you want to use shared user defaults, just
///  redefine this global shortcut in your app target, like so:
///  ~~~
///  var Defaults = UserDefaults(suiteName: "com.my.app")!
///  ~~~

public let Defaults = UserDefaults.standard

// MARK: - Static keys

/// Extend this class and add your user defaults keys as static constants
/// so you can use the shortcut dot notation (e.g. `Defaults[.yourKey]`)

open class DefaultsKeys {
    fileprivate init() {}
}

/// Base class for static user defaults keys. Specialize with value type
/// and pass key name to the initializer to create a key.

open class DefaultsKey<ValueType>: DefaultsKeys {
    // TODO: Can we use protocols to ensure ValueType is a compatible type?
    public let _key: String
    
    public init(_ key: String) {
        self._key = key
        super.init()
    }
}

// This one is tricky because we can't (and don't want to) extend Codable
// so it implements DefaultsSerializable. So we have 3 cases:
// - There is a Codable that wants to be saved (default saving)
// - There is a custom object that wants to be saved, but it doesn't implement Codable
// - There is a Codable that wants a custom getter/setter
extension UserDefaults {
    subscript<T: Codable>(key: DefaultsKey<T>) -> T? {
        get {
            return T.get(key: key._key, userDefaults: self)
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T? {
        get {
            return T.get(key: key._key, userDefaults: self)
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: Codable & DefaultsSerializable>(key: DefaultsKey<T>) -> T? {
        get {
            return T.get(key: key._key, userDefaults: self)
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }
}

extension UserDefaults {
    /// Returns `true` if `key` exists
    
    public func hasKey<T>(_ key: DefaultsKey<T>) -> Bool {
        return object(forKey: key._key) != nil
    }
    
    /// Removes value for `key`
    
    public func remove<T>(_ key: DefaultsKey<T>) {
        removeObject(forKey: key._key)
    }
}qwww

// MARK: Static subscripts for array types

extension UserDefaults {
    public subscript(key: DefaultsKey<[Any]?>) -> [Any]? {
        get { return array(forKey: key._key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Any]>) -> [Any] {
        get { return array(forKey: key._key) ?? [] }
        set { set(key, newValue) }
    }
}

// We need the <T: AnyObject> and <T: _ObjectiveCBridgeable> variants to
// suppress compiler warnings about NSArray not being convertible to [T]
// AnyObject is for NSData and NSDate, _ObjectiveCBridgeable is for value
// types bridge-able to Foundation types (String, Int, ...)

extension UserDefaults {
    public func getArray<T: _ObjectiveCBridgeable>(_ key: DefaultsKey<[T]>) -> [T] {
        return array(forKey: key._key) as NSArray? as? [T] ?? []
    }
    
    public func getArray<T: _ObjectiveCBridgeable>(_ key: DefaultsKey<[T]?>) -> [T]? {
        return array(forKey: key._key) as NSArray? as? [T]
    }
    
    public func getArray<T: Any>(_ key: DefaultsKey<[T]>) -> [T] {
        return array(forKey: key._key) as NSArray? as? [T] ?? []
    }
    
    public func getArray<T: Any>(_ key: DefaultsKey<[T]?>) -> [T]? {
        return array(forKey: key._key) as NSArray? as? [T]
    }
}

extension UserDefaults {
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
    
    public subscript(key: DefaultsKey<[Data]?>) -> [Data]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Data]>) -> [Data] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Date]?>) -> [Date]? {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
    
    public subscript(key: DefaultsKey<[Date]>) -> [Date] {
        get { return getArray(key) }
        set { set(key, newValue) }
    }
}

// MARK: - Archiving custom types

// MARK: RawRepresentable

extension UserDefaults {
    // TODO: Ensure that T.RawValue is compatible
    public func archive<T: RawRepresentable>(_ key: DefaultsKey<T>, _ value: T) {
        set(key, value.rawValue)
    }
    
    public func archive<T: RawRepresentable>(_ key: DefaultsKey<T?>, _ value: T?) {
        if let value = value {
            set(key, value.rawValue)
        } else {
            remove(key)
        }
    }
    
    public func unarchive<T: RawRepresentable>(_ key: DefaultsKey<T?>) -> T? {
        return object(forKey: key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
    
    public func unarchive<T: RawRepresentable>(_ key: DefaultsKey<T>) -> T? {
        return object(forKey: key._key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }
}

// MARK: NSCoding

extension UserDefaults {
    // TODO: Can we simplify this and ensure that T is NSCoding compliant?

    public func archive<T>(_ key: DefaultsKey<T>, _ value: T) {
        set(key, NSKeyedArchiver.archivedData(withRootObject: value))
    }

    public func archive<T>(_ key: DefaultsKey<T?>, _ value: T?) {
        if let value = value {
            set(key, NSKeyedArchiver.archivedData(withRootObject: value))
        } else {
            remove(key)
        }
    }
    
    public func unarchive<T>(_ key: DefaultsKey<T>) -> T? {
        return data(forKey: key._key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
    }
    
    public func unarchive<T>(_ key: DefaultsKey<T?>) -> T? {
        return data(forKey: key._key).flatMap { NSKeyedUnarchiver.unarchiveObject(with: $0) } as? T
    }
}
