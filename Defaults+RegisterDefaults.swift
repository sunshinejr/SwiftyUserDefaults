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

public protocol DefaultsKeyable {
    var _key: String { get }
    var _defaultValue: Any? { get }
}

extension DefaultsKey: DefaultsKeyable {
    public var _defaultValue: Any? {
        return self.defaultValue as Any?
    }
}

public extension UserDefaults {
    func register(defaultsKeys: [DefaultsKeyable]) {
        self.register(defaults: defaultsKeys.dictionaryWithDefaultValues())
    }
}

public extension Array where Element == DefaultsKeyable {
    /// - returns: Dictionary with pairs of `DefaultsKey` keys and default values. Does not contain keys
    ///   where the default value is `nil`.
    func dictionaryWithDefaultValues() -> [String : Any] {
        return self
            .filter { $0._defaultValue != nil }
            .mapDictionary { ($0._key, $0._defaultValue!) }
    }
}

internal extension Array {
    func mapDictionary<K, V>(_ transform: (Element) -> ((K, V))) -> [K : V] {
        var result: [K : V] = [:]
        for element in self {
            let (key, value) = transform(element)
            result[key] = value
        }
        return result
    }
}
