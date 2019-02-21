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

// DefaultsKey
public extension UserDefaults {

    subscript<T: DefaultsSerializable>(key: DefaultsKey<T?>) -> T.T? {
        get {
            if let value = T._defaults.get(key: key._key, userDefaults: self) {
                return value
            } else if let defaultValue = key.defaultValue as? T.T {
                return defaultValue
            } else {
                return nil
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
