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

extension DefaultsSerializable {
    public static var _defaultsArray: DefaultsArrayBridge<[T]> { return DefaultsArrayBridge() }
}
extension Date: DefaultsSerializable {
    public static var _defaults: DefaultsObjectBridge<Date> { return DefaultsObjectBridge() }
}
extension String: DefaultsSerializable {
    public static var _defaults: DefaultsStringBridge { return DefaultsStringBridge() }
}
extension Int: DefaultsSerializable {
    public static var _defaults: DefaultsIntBridge { return DefaultsIntBridge() }
}
extension Double: DefaultsSerializable {
    public static var _defaults: DefaultsDoubleBridge { return DefaultsDoubleBridge() }
}
extension Bool: DefaultsSerializable {
    public static var _defaults: DefaultsBoolBridge { return DefaultsBoolBridge() }
}
extension Data: DefaultsSerializable {
    public static var _defaults: DefaultsDataBridge { return DefaultsDataBridge() }
}

extension URL: DefaultsSerializable {
    #if os(Linux)
    public static var _defaults: DefaultsKeyedArchiverBridge<URL> { return DefaultsKeyedArchiverBridge() }
    #else
    public static var _defaults: DefaultsUrlBridge { return DefaultsUrlBridge() }
    #endif
    public static var _defaultsArray: DefaultsKeyedArchiverBridge<[URL]> { return DefaultsKeyedArchiverBridge() }
}

extension DefaultsSerializable where Self: Codable {
    public static var _defaults: DefaultsCodableBridge<Self> { return DefaultsCodableBridge() }
    public static var _defaultsArray: DefaultsCodableBridge<[Self]> { return DefaultsCodableBridge() }
}

extension DefaultsSerializable where Self: RawRepresentable {
    public static var _defaults: DefaultsRawRepresentableBridge<Self> { return DefaultsRawRepresentableBridge() }
    public static var _defaultsArray: DefaultsRawRepresentableArrayBridge<[Self]> { return DefaultsRawRepresentableArrayBridge() }
}

extension DefaultsSerializable where Self: NSCoding {
    public static var _defaults: DefaultsKeyedArchiverBridge<Self> { return DefaultsKeyedArchiverBridge() }
    public static var _defaultsArray: DefaultsKeyedArchiverBridge<[Self]> { return DefaultsKeyedArchiverBridge() }
}

extension Dictionary: DefaultsSerializable where Key == String {
    public typealias T = [Key: Value]
    public typealias Bridge = DefaultsObjectBridge<T>
    public typealias ArrayBridge = DefaultsArrayBridge<[T]>
    public static var _defaults: Bridge { return Bridge() }
    public static var _defaultsArray: ArrayBridge { return ArrayBridge() }
}
extension Array: DefaultsSerializable where Element: DefaultsSerializable {
    public typealias T = [Element.T]
    public typealias Bridge = Element.ArrayBridge
    public typealias ArrayBridge = DefaultsObjectBridge<[T]>
    public static var _defaults: Bridge {
        return Element._defaultsArray
    }
    public static var _defaultsArray: ArrayBridge {
        fatalError("Multidimensional arrays are not supported yet")
    }
}

extension Optional: DefaultsSerializable where Wrapped: DefaultsSerializable {
    public typealias Bridge = DefaultsOptionalBridge<Wrapped.Bridge>
    public typealias ArrayBridge = DefaultsOptionalBridge<Wrapped.ArrayBridge>

    public static var _defaults: DefaultsOptionalBridge<Wrapped.Bridge> { return DefaultsOptionalBridge(bridge: Wrapped._defaults) }
    public static var _defaultsArray: DefaultsOptionalBridge<Wrapped.ArrayBridge> { return DefaultsOptionalBridge(bridge: Wrapped._defaultsArray) }
}
