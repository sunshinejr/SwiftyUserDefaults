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

public protocol DefaultsBridge {

    associatedtype T

    /// This method provides a way of saving your data in UserDefaults. Usually needed
    /// when you want to create your custom Bridge, so you'll have to override it.
    func get(key: String, userDefaults: UserDefaults) -> T?

    /// This method provides a way of saving your data in UserDefaults. Usually needed
    /// when you want to create your custom Bridge, so you'll have to override it.
    func save(key: String, value: T?, userDefaults: UserDefaults)

    /// Override this function if your data is represented differently in UserDefaults
    /// and you map it in save/get methods.
    ///
    /// For instance, if you store it as Data in UserDefaults, but your type is not Data in your
    /// defaults key, then you need to provide `deserialize(_:)` method as well.
    ///
    /// Similar if you store your array of type as e.g. `[String]` but the type you use is actually `[SomeClassThatHasOnlyOneStringProperty]`.
    ///
    /// See `DefaultsRawRepresentableBridge` or `DefaultsCodableBridge` for examples.
    func deserialize(_ object: Any) -> T?
}

public struct DefaultsObjectBridge<T>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.object(forKey: key) as? T
    }

    public func deserialize(_ object: Any) -> T? {
        return nil
    }
}

public struct DefaultsArrayBridge<T: Collection>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.array(forKey: key) as? T
    }

    public func deserialize(_ object: Any) -> T? {
        return nil
    }
}

public struct DefaultsStringBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: String?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> String? {
        return userDefaults.string(forKey: key)
    }

    public func deserialize(_ object: Any) -> String? {
        return nil
    }
}

public struct DefaultsIntBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Int?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Int? {
        if let int = userDefaults.number(forKey: key)?.intValue {
            return int
        }

        // Fallback for launch arguments
        if let string = userDefaults.object(forKey: key) as? String,
            let int = Int(string) {
            return int
        }

        return nil
    }

    public func deserialize(_ object: Any) -> Int? {
        return nil
    }
}

public struct DefaultsDoubleBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Double?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Double? {
        if let double = userDefaults.number(forKey: key)?.doubleValue {
            return double
        }

        // Fallback for launch arguments
        if let string = userDefaults.object(forKey: key) as? String,
            let double = Double(string) {
            return double
        }

        return nil
    }

    public func deserialize(_ object: Any) -> Double? {
        return nil
    }
}

public struct DefaultsBoolBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Bool?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Bool? {
        // @warning we use number(forKey:) instead of bool(forKey:), because
        // bool(forKey:) will always return a value, even if it's not set
        //
        // Now, let's see if there is value in defaults that converts to Bool first:
        if let bool = userDefaults.number(forKey: key)?.boolValue {
            return bool
        }

        // If not, fallback for values saved in a plist (e.g. for testing)
        // For instance, few of the string("YES", "true", "NO", "false") convert to Bool from a property list
        return (userDefaults.object(forKey: key) as? String)?.bool
    }

    public func deserialize(_ object: Any) -> Bool? {
        return nil
    }
}

public struct DefaultsDataBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: Data?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> Data? {
        return userDefaults.data(forKey: key)
    }

    public func deserialize(_ object: Any) -> Data? {
        return nil
    }
}

public struct DefaultsUrlBridge: DefaultsBridge {

    public init() {}

    public func save(key: String, value: URL?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> URL? {
        return userDefaults.url(forKey: key)
    }

    public func deserialize(_ object: Any) -> URL? {
        if let object = object as? URL {
            return object
        }

        if let object = object as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: object) as? URL
        }

        if let object = object as? NSString {
            let path = object.expandingTildeInPath
            return URL(fileURLWithPath: path)
        }

        return nil
    }
}

public struct DefaultsCodableBridge<T: Codable>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }
        userDefaults.set(encodable: value, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return deserialize(data)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let data = object as? Data else { return nil }

        return try? JSONDecoder().decode(T.self, from: data)
    }
}

public struct DefaultsKeyedArchiverBridge<T>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
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

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return deserialize(data)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let data = object as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
    }
}

public struct DefaultsRawRepresentableBridge<T: RawRepresentable>: DefaultsBridge {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(value?.rawValue, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let object = userDefaults.object(forKey: key) else { return nil }
        return deserialize(object)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let rawValue = object as? T.RawValue else { return nil }
        return T(rawValue: rawValue)
    }
}

public struct DefaultsRawRepresentableArrayBridge<T: Collection>: DefaultsBridge where T.Element: RawRepresentable {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        let raw = value?.map { $0.rawValue }
        userDefaults.set(raw, forKey: key)
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        guard let object = userDefaults.array(forKey: key) else { return nil }
        return deserialize(object)
    }

    public func deserialize(_ object: Any) -> T? {
        guard let rawValue = object as? [T.Element.RawValue] else { return nil }
        return rawValue.compactMap { T.Element(rawValue: $0) } as? T
    }
}

public struct DefaultsOptionalBridge<Bridge: DefaultsBridge>: DefaultsBridge {

    public typealias T = Bridge.T?

    private let bridge: Bridge

    init(bridge: Bridge) {
        self.bridge = bridge
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return bridge.get(key: key, userDefaults: userDefaults)
    }

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        bridge.save(key: key, value: value as? Bridge.T, userDefaults: userDefaults)
    }

    public func deserialize(_ object: Any) -> T? {
        return bridge.deserialize(object)
    }
}

public struct DefaultsOptionalArrayBridge<Bridge: DefaultsBridge>: DefaultsBridge where Bridge.T: Collection {

    public typealias T = Bridge.T?

    private let bridge: Bridge

    init(bridge: Bridge) {
        self.bridge = bridge
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
        return bridge.get(key: key, userDefaults: userDefaults)
    }

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        bridge.save(key: key, value: value as? Bridge.T, userDefaults: userDefaults)
    }

    public func deserialize(_ object: Any) -> T? {
        return bridge.deserialize(object)
    }
}
