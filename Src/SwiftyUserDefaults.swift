//
// SwiftyUserDefaults
//
// Copyright (c) 2015 Radosław Pietruszewski
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

public extension NSUserDefaults {
    class Proxy {
        private let defaults: NSUserDefaults
        private let key: String
        
        private init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: Getters
        
        public var object: NSObject? {
            return defaults.objectForKey(key) as NSObject?
        }
        
        public var string: String? {
            return defaults.stringForKey(key)
        }
        
        public var array: NSArray? {
            return defaults.arrayForKey(key)
        }
        
        public var dictionary: NSDictionary? {
            return defaults.dictionaryForKey(key)
        }
        
        public var data: NSData? {
            return defaults.dataForKey(key)
        }
        
        public var date: NSDate? {
            return object as? NSDate
        }
        
        public var number: NSNumber? {
            return object as? NSNumber
        }
        
        public var int: Int? {
            return number?.integerValue
        }
        
        public var double: Double? {
            return number?.doubleValue
        }
        
        public var bool: Bool? {
            return number?.boolValue
        }
    }
    
    /// Returns getter proxy for `key`
    
    public subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
    
    /// Sets value for `key`
    
    public subscript(key: String) -> Any? {
        get {
            return self[key]
        }
        set {
            if let v = newValue as? Int {
                setInteger(v, forKey: key)
            } else if let v = newValue as? Double {
                setDouble(v, forKey: key)
            } else if let v = newValue as? Bool {
                setBool(v, forKey: key)
            } else if let v = newValue as? NSObject {
                setObject(v, forKey: key)
            } else if newValue == nil {
                removeObjectForKey(key)
            } else {
                assertionFailure("Invalid value type")
            }
        }
    }
    
    /// Returns `true` if `key` exists
    
    public func hasKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    
    /// Removes value for `key`
    
    public func remove(key: String) {
        removeObjectForKey(key)
    }
}

infix operator ?= {
    associativity right
    precedence 90
}

/// If key doesn't exist, sets its value to `expr`
/// Note: This isn't the same as `Defaults.registerDefaults`. This method saves the new value to disk, whereas `registerDefaults` only modifies the defaults in memory.
/// Note: If key already exists, the expression after ?= isn't evaluated

public func ?= (proxy: NSUserDefaults.Proxy, expr: @autoclosure () -> Any) {
    if !proxy.defaults.hasKey(proxy.key) {
        proxy.defaults[proxy.key] = expr()
    }
}

/// Adds `b` to the key (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to `b`

public func += (proxy: NSUserDefaults.Proxy, b: Int) {
    let a = proxy.defaults[proxy.key].int ?? 0
    proxy.defaults[proxy.key] = a + b
}

public func += (proxy: NSUserDefaults.Proxy, b: Double) {
    let a = proxy.defaults[proxy.key].double ?? 0
    proxy.defaults[proxy.key] = a + b
}

/// Icrements key by one (and saves it as an integer)
/// If key doesn't exist or isn't a number, sets value to 1

public postfix func ++ (proxy: NSUserDefaults.Proxy) {
    proxy += 1
}

/// Global shortcut for NSUserDefaults.standardUserDefaults()

public let Defaults = NSUserDefaults.standardUserDefaults()
