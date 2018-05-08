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

// DefaultsKey
public extension UserDefaults {

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T?>) -> T? {
        get {
            return T.get(key: key._key, userDefaults: self) ?? key.defaultValue as? T
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T?>) -> T? where T: DefaultsDefaultValueType {
        get {
            return T.get(key: key._key, userDefaults: self) ?? key.defaultValue ?? T.defaultValue
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T?>) -> T? where T: Collection, T.Element: DefaultsDefaultArrayValueType {
        get {
            return T.get(key: key._key, userDefaults: self) ?? key.defaultValue ?? T.Element.defaultArrayValue as? T
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T where T: DefaultsDefaultValueType {
        get {
            return T.get(key: key._key, userDefaults: self) ?? key.defaultValue ?? T.defaultValue
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T where T: Collection, T.Element: DefaultsDefaultArrayValueType {
        get {
            // There _must_ be a value: you can't create a key without a default value in type or in the key itself
            return T.get(key: key._key, userDefaults: self) ?? key.defaultValue ?? T.Element.defaultArrayValue as! T // swiftlint:disable:this force_cast
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T {
        get {
            if let value = T.get(key: key._key, userDefaults: self) {
                return value
            } else if let defaultValue = key.defaultValue {
                return defaultValue
            } else {
                fatalError("Shouldn't really happen, `DefaultsKey` can be initialized only with defaultValue or with a type that conforms to `DefaultsDefaultValueType`.")
            }
        }
        set {
            T.save(key: key._key, value: newValue, userDefaults: self)
        }
    }
}
