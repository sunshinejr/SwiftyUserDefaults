//
// SwiftyUserDefaults
//
// Copyright (c) 2015-2018 Radosław Pietruszewski, Łukasz Mróz
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

// MARK: - Static keys

/// Extend this class and add your user defaults keys as static constants
/// so you can use the shortcut dot notation (e.g. `Defaults[.yourKey]`)

open class DefaultsKeys {
    fileprivate init() {}
}

/// Base class for static user defaults keys. Specialize with value type
/// and pass key name to the initializer to create a key.
open class DefaultsKey<ValueType: DefaultsSerializable>: DefaultsKeys {

    public let _key: String
    internal let defaultValue: ValueType?

    public init(_ key: String, defaultValue: ValueType) {
        self._key = key
        self.defaultValue = defaultValue
    }

    // Couldn't figure out a way of how to pass a nil/none value from extension, thus this initializer.
    // Used for creating an optional key (without defaultValue)
    private init(key: String) {
        self._key = key
        self.defaultValue = nil
    }

    @available(*, unavailable, message: "This key needs a default value, either using an argument or a type with implemented `defaultValue`. If this type does not have a default value, consider using an optional key.")
    public init(_ key: String) {
        fatalError()
    }
}

extension DefaultsKey where ValueType: Collection, ValueType.Element: DefaultsSerializable {

    @available(*, unavailable, message: "Even though element of this array has a default value, the whole array doesnt and so you need to either pass it via argument or in extension.")
    public convenience init(_ key: String) {
        fatalError()
    }
}

public extension DefaultsKey where ValueType: DefaultsSerializable, ValueType: OptionalType, ValueType.Wrapped: DefaultsSerializable {

    convenience init(_ key: String) {
        self.init(key: key)
    }
}

public extension DefaultsKey where ValueType: DefaultsDefaultValueType {

    convenience init(_ key: String) {
        self.init(key: key)
    }
}

public extension DefaultsKey where ValueType: Collection, ValueType.Element: DefaultsDefaultArrayValueType, ValueType.Element: DefaultsSerializable {

    convenience init(_ key: String) {
        self.init(key: key)
    }
}

extension Optional: DefaultsSerializable where Wrapped: DefaultsSerializable {

    public static func get(key: String, userDefaults: UserDefaults) -> Wrapped?? {
        return Wrapped.get(key: key, userDefaults: userDefaults)
    }

    public static func getArray(key: String, userDefaults: UserDefaults) -> [Wrapped?]? {
        return Wrapped.getArray(key: key, userDefaults: userDefaults)
    }

    public static func save(key: String, value: Wrapped??, userDefaults: UserDefaults) {
        if let _value = value, let value = _value {
            Wrapped.save(key: key, value: value, userDefaults: userDefaults)
        } else {
            Wrapped.save(key: key, value: nil, userDefaults: userDefaults)
        }
    }

    public static func saveArray(key: String, value: [Wrapped?], userDefaults: UserDefaults) {
        Wrapped.saveArray(key: key, value: value.compactMap { $0 }, userDefaults: userDefaults)
    }
}
