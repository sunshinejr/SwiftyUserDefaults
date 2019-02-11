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

public class DefaultsBridge<T>: DefaultsBridgeType {

    public init() {}

    public func save(key: String, value: T?, userDefaults: UserDefaults) {
        fatalError("This Bridge wasn't subclassed! Please do so before using it in your type.")
    }

    public func get(key: String, userDefaults: UserDefaults) -> T? {
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

extension Date: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<Date> { return DefaultsObjectBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Date]> { return DefaultsArrayBridge() }
}

extension String: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<String> { return DefaultsStringBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[String]> { return DefaultsArrayBridge() }
}

public final class DefaultsIntBridge: DefaultsBridge<Int> {
    public override func save(key: String, value: Int?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Int? {
        return userDefaults.number(forKey: key)?.intValue
    }
}

extension Int: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<Int> { return DefaultsIntBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Int]> { return DefaultsArrayBridge() }
}

public final class DefaultsDoubleBridge: DefaultsBridge<Double> {
    public override func save(key: String, value: Double?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Double? {
        return userDefaults.number(forKey: key)?.doubleValue
    }
}

extension Double: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<Double> { return DefaultsDoubleBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Double]> { return DefaultsArrayBridge() }
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

extension Bool: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<Bool> { return DefaultsBoolBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Bool]> { return DefaultsArrayBridge() }
}

public final class DefaultsDataBridge: DefaultsBridge<Data> {
    public override func save(key: String, value: Data?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> Data? {
        return userDefaults.data(forKey: key)
    }
}

extension Data: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<Data> { return DefaultsDataBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Data]> { return DefaultsArrayBridge() }
}

public final class DefaultsUrlBridge: DefaultsBridge<URL> {
    public override func save(key: String, value: URL?, userDefaults: UserDefaults) {
        userDefaults.set(value, forKey: key)
    }

    public override func get(key: String, userDefaults: UserDefaults) -> URL? {
        return userDefaults.url(forKey: key)
    }
}

extension URL: DefaultsSerializable {
    public static var defaults_bridge: DefaultsBridge<URL> { return DefaultsUrlBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[URL]> { return DefaultsKeyedArchiverBridge() }
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

extension DefaultsSerializable where Self: Encodable, Self: Decodable {
    public static var defaults_bridge: DefaultsBridge<Self> { return DefaultsCodableBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Self]> { return DefaultsCodableBridge() }
}


public final class DefaultsKeyedArchiverBridge<T>: DefaultsBridge<T> {

    public override func get(key: String, userDefaults: UserDefaults) -> T? {
        return userDefaults.data(forKey: key).flatMap(NSKeyedUnarchiver.unarchiveObject) as? T
    }

    public override func save(key: String, value: T?, userDefaults: UserDefaults) {
        userDefaults.set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
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

extension DefaultsSerializable where Self: RawRepresentable {
    public static var defaults_bridge: DefaultsBridge<Self> { return DefaultsRawRepresentableBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Self]> { return DefaultsRawRepresentableArrayBridge() }
}

extension DefaultsSerializable where Self: NSCoding {
    public static var defaults_bridge: DefaultsBridge<Self> { return DefaultsKeyedArchiverBridge() }
    public static var defaults_arrayBridge: DefaultsBridge<[Self]> { return DefaultsKeyedArchiverBridge() }
}

extension Array: DefaultsSerializable where Element: DefaultsSerializable {

    public typealias T = [Element]

    public static var defaults_bridge: DefaultsBridge<[Element]> {
        return Element.defaults_arrayBridge as! DefaultsBridge<[Element]>
    }

    public static var defaults_arrayBridge: DefaultsBridge<[[Element]]> {
        fatalError("More than 2D arrays not supported yet")
    }
}

extension Optional: DefaultsSerializable where Wrapped: DefaultsSerializable {
    public typealias T = Wrapped

    public static var defaults_bridge: DefaultsBridge<Wrapped> { return Wrapped.defaults_bridge as! DefaultsBridge<Wrapped> }

    public static var defaults_arrayBridge: DefaultsBridge<[Wrapped]> { return Wrapped.defaults_arrayBridge as! DefaultsBridge<[Wrapped]> }
}
