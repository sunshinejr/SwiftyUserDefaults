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

internal extension Decodable {

    static func get(key: String, userDefaults: UserDefaults) -> Self? {
        // We switch using T type due to backwards compatibility.
        // Example: Int is Codable, but it was saved using `object(forKey:)`
        // Right now it would be saved by decoding into Data and then read using
        // data(forKey:). Which means it won't be able to read old String in the
        // UserDefaults because it was saved as a String, but now we want Data.
        //
        // I mean, we _could_ potentially think about backporting/migrating
        // values in the older versions, or just say that
        switch self.self {
        case is String.Type:
            return userDefaults.string(forKey: key) as? Self
        case is Int.Type:
            return userDefaults.number(forKey: key)?.intValue as? Self
        case is Double.Type:
            return userDefaults.number(forKey: key)?.doubleValue as? Self
        case is Bool.Type:
            // @warning we use number(forKey:) instead of bool(forKey:), because
            // bool(forKey:) will always return value, even if it's not set
            // and it does a little bit of magic under the hood as well
            // e.g. transforming strings like "YES" or "true" to true
            return userDefaults.number(forKey: key)?.boolValue as? Self
        case is Data.Type:
            return userDefaults.data(forKey: key) as? Self
        case is Date.Type:
            return userDefaults.object(forKey: key) as? Self
        case is URL.Type:
            return userDefaults.url(forKey: key) as? Self
        default:
            return userDefaults.decodable(forKey: key) as Self?
        }
    }
}

internal extension Encodable {
    static func save(key: String, value: Self?, userDefaults: UserDefaults) {
        guard let value = value else {
            userDefaults.removeObject(forKey: key)
            return
        }

        switch value {
        // @warning This should always be on top of Int because a cast
        // from Double to Int will always succeed.
        case let v as Double: userDefaults.set(v, forKey: key)
        case let v as Int: userDefaults.set(v, forKey: key)
        case let v as Bool: userDefaults.set(v, forKey: key)
        case let v as URL: userDefaults.set(v, forKey: key)
        default: userDefaults.set(encodable: value, forKey: key)
        }
    }
}
