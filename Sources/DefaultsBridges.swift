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

open class DefaultsBridge<T>: DefaultsBridgeType {

    public init() {}

    open func save(key: String, value: T?, userDefaults: UserDefaults) {
        fatalError("This Bridge wasn't subclassed! Please do so before using it in your type.")
    }

    open func get(key: String, userDefaults: UserDefaults) -> T? {
        fatalError("This Bridge wasn't subclassed! Please do so before using it in your type.")
    }
}

public final class DefaultsObjectBridge<T>: DefaultsBridge<T> {
    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
}

public final class DefaultsArrayBridge<T: Collection>: DefaultsBridge<T> {
    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.array(forKey: key) as? T
    }
}

public final class DefaultsStringBridge: DefaultsBridge<String> {
    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.string(forKey: key)
    }
}

public final class DefaultsIntBridge: DefaultsBridge<Int> {
    public override func save(key: String, value: Int?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Int? {
        return userDefaults.number(forKey: key)?.intValue
    }
}

public final class DefaultsDoubleBridge: DefaultsBridge<Double> {
    public override func save(key: String, value: Double?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Double? {
        return userDefaults.number(forKey: key)?.doubleValue
    }
}

public final class DefaultsBoolBridge: DefaultsBridge<Bool> {
    public override func save(key: String, value: Bool?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Bool? {
        // @warning we use number(forKey:) instead of bool(forKey:), because
        // bool(forKey:) will always return value, even if it's not set
        // and it does a little bit of magic under the hood as well
        // e.g. transforming strings like "YES" or "true" to true
        return userDefaults.number(forKey: key)?.boolValue
    }
}

public final class DefaultsDataBridge: DefaultsBridge<Data> {
    public override func save(key: String, value: Data?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Data? {
        return userDefaults.data(forKey: key)
    }
}

public final class DefaultsUrlBridge: DefaultsBridge<URL> {
    public override func save(key: String, value: URL?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> URL? {
        return userDefaults.url(forKey: key)
    }
}

public final class DefaultsCodableBridge<T: Codable>: DefaultsBridge<T> {

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }
        userDefaults.set(encodable: value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.decodable(forKey: key) as T?
    }
}

public final class DefaultsKeyedArchiverBridge<T>: DefaultsBridge<T> {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.data(forKey: key).flatMap(NSKeyedUnarchiver.unarchiveObject) as? T
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }

        // Needed because Quick/Nimble have min target 10.10...
        if #available(OSX 10.11, *) {
            userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
        } else {
            fatalError("Shouldn't really happen. We do not support macOS 10.10, if it happened to you please report your use-case on GitHub issues.")
        }
    }
}

public final class DefaultsRawRepresentableBridge<T: RawRepresentable>: DefaultsBridge<T> {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.object(forKey: key).flatMap { T(rawValue: $0 as! T.RawValue) }
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value?.rawValue, forKey: key)
    }
}

public final class DefaultsRawRepresentableArrayBridge<T: Collection>: DefaultsBridge<T> where T.Element: RawRepresentable {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.array(forKey: key)?.compactMap { T.Element(rawValue: $0 as! T.Element.RawValue) } as? T
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        let raw = value?.map { $0.rawValue }

        userDefaults.set(raw, forKey: key)
    }
}
