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

extension Date: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Date> { return DefaultsObjectBridge() }
    public static var _defaultsArray: DefaultsBridge<[Date]> { return DefaultsArrayBridge() }
}

extension String: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<String> { return DefaultsStringBridge() }
    public static var _defaultsArray: DefaultsBridge<[String]> { return DefaultsArrayBridge() }
}

extension Int: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Int> { return DefaultsIntBridge() }
    public static var _defaultsArray: DefaultsBridge<[Int]> { return DefaultsArrayBridge() }
}

extension Double: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Double> { return DefaultsDoubleBridge() }
    public static var _defaultsArray: DefaultsBridge<[Double]> { return DefaultsArrayBridge() }
}

extension Bool: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Bool> { return DefaultsBoolBridge() }
    public static var _defaultsArray: DefaultsBridge<[Bool]> { return DefaultsArrayBridge() }
}

extension Data: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<Data> { return DefaultsDataBridge() }
    public static var _defaultsArray: DefaultsBridge<[Data]> { return DefaultsArrayBridge() }
}

extension URL: DefaultsSerializable {
    public static var _defaults: DefaultsBridge<URL> {
        #if os(Linux)
            return DefaultsKeyedArchiverBridge()
        #else
            return DefaultsUrlBridge()
        #endif
    }
    public static var _defaultsArray: DefaultsBridge<[URL]> { return DefaultsKeyedArchiverBridge() }
}

extension DefaultsSerializable where Self: Encodable, Self: Decodable {
    public static var _defaults: DefaultsBridge<Self> { return DefaultsCodableBridge() }
    public static var _defaultsArray: DefaultsBridge<[Self]> { return DefaultsCodableBridge() }
}

extension DefaultsSerializable where Self: RawRepresentable {
    public static var _defaults: DefaultsBridge<Self> { return DefaultsRawRepresentableBridge() }
    public static var _defaultsArray: DefaultsBridge<[Self]> { return DefaultsRawRepresentableArrayBridge() }
}

extension DefaultsSerializable where Self: NSCoding {
    public static var _defaults: DefaultsBridge<Self> { return DefaultsKeyedArchiverBridge() }
    public static var _defaultsArray: DefaultsBridge<[Self]> { return DefaultsKeyedArchiverBridge() }
}

extension Dictionary: DefaultsSerializable where Key == String {

    public typealias T = [Key: Value]

    public static var _defaults: DefaultsBridge<[Key: Value]> { return DefaultsObjectBridge() }
    public static var _defaultsArray: DefaultsBridge<[[Key: Value]]> { return DefaultsArrayBridge() }
}

extension Array: DefaultsSerializable where Element: DefaultsSerializable {

    public typealias T = [Element]

    public static var _defaults: DefaultsBridge<[Element]> {
        // swiftlint:disable:next force_cast
        return Element._defaultsArray as! DefaultsBridge<[Element]>
    }

    public static var _defaultsArray: DefaultsBridge<[[Element]]> {
        fatalError("Multidimensional arrays are not supported yet")
    }
}

extension Optional: DefaultsSerializable where Wrapped: DefaultsSerializable {
    public typealias T = Wrapped

    // swiftlint:disable:next force_cast
    public static var _defaults: DefaultsBridge<Wrapped> { return Wrapped._defaults as! DefaultsBridge<Wrapped> }

    // swiftlint:disable:next force_cast
    public static var _defaultsArray: DefaultsBridge<[Wrapped]> { return Wrapped._defaultsArray as! DefaultsBridge<[Wrapped]> }
}
