//
// SwiftyUserDefaults
//
// Copyright (c) 2015-present Radosław Pietruszewski, Łukasz Mróz
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

public protocol DefaultsProviding {
    associatedtype KeyStore: DefaultsKeyStore
    
    subscript<T: DefaultsSerializable>(key key: DefaultsKey<T>) -> T.T where T: OptionalType, T.T == T { get nonmutating set }
    subscript<T: DefaultsSerializable>(key key: DefaultsKey<T>) -> T.T where T.T == T { get nonmutating set }
    subscript<T: DefaultsSerializable>(keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T: OptionalType, T.T == T { get nonmutating set }
    subscript<T: DefaultsSerializable>(keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T.T == T { get nonmutating set }
    subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T: OptionalType, T.T == T { get nonmutating set }
    subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T.T == T { get nonmutating set }
}

extension DefaultsAdapter: DefaultsProviding {
    public subscript<T: DefaultsSerializable>(key key: DefaultsKey<T>) -> T.T where T: OptionalType, T.T == T {
        get {
            return defaults[key]
        }
        nonmutating set {
            defaults[key] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(key key: DefaultsKey<T>) -> T.T where T.T == T {
        get {
            return defaults[key]
        }
        nonmutating set {
            defaults[key] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T: OptionalType, T.T == T {
        get {
            return defaults[keyStore[keyPath: keyPath]]
        }
        nonmutating set {
            defaults[keyStore[keyPath: keyPath]] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T.T == T {
        get {
            return defaults[keyStore[keyPath: keyPath]]
        }
        nonmutating set {
            defaults[keyStore[keyPath: keyPath]] = newValue
        }
    }

    // Weird flex, but needed these two for the dynamicMemberLookup :shrug:

    public subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T: OptionalType, T.T == T {
        get {
            return self[keyPath]
        }
        nonmutating set {
            self[keyPath] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T.T == T {
        get {
            return self[keyPath]
        }
        nonmutating set {
            self[keyPath] = newValue
        }
    }
}

public extension UserDefaults {

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T.T where T: OptionalType, T.T == T {
        get {
            if let value = T._defaults.get(key: key._key, userDefaults: self), let _value = value as? T.T.Wrapped {
                // swiftlint:disable:next force_cast
                return _value as! T
            } else if let defaultValue = key.defaultValue {
                return defaultValue
            } else {
                return T.T.__swifty_empty
            }
        }
        set {
            T._defaults.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T.T where T.T == T {
        get {
            if let value = T._defaults.get(key: key._key, userDefaults: self) {
                return value
            } else if let defaultValue = key.defaultValue {
                return defaultValue
            } else {
                fatalError("Shouldn't happen, please report!")
            }
        }
        set {
            T._defaults.save(key: key._key, value: newValue, userDefaults: self)
        }
    }
}
