import Foundation

extension NSUserDefaults {
    class Proxy {
        private let defaults: NSUserDefaults
        private let key: String
        
        private init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        // MARK: Getters
        
        var object: NSObject? {
            return defaults.objectForKey(key) as NSObject?
        }
        
        var string: String? {
            return defaults.stringForKey(key)
        }
        
        var array: NSArray? {
            return defaults.arrayForKey(key)
        }
        
        var dictionary: NSDictionary? {
            return defaults.dictionaryForKey(key)
        }
        
        var data: NSData? {
            return defaults.dataForKey(key)
        }
        
        var date: NSDate? {
            return object as? NSDate
        }
        
        var number: NSNumber? {
            return object as? NSNumber
        }
        
        var int: Int? {
            return number?.integerValue
        }
        
        var double: Double? {
            return number?.doubleValue
        }
        
        var bool: Bool? {
            return number?.boolValue
        }
    }
    
    /// Returns getter proxy for `key`
    
    subscript(key: String) -> Proxy {
        return Proxy(self, key)
    }
    
    /// Sets value for `key`
    
    subscript(key: String) -> Any? {
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
    
    func hasKey(key: String) -> Bool {
        return objectForKey(key) != nil
    }
    
    /// Removes value for `key`
    
    func remove(key: String) {
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

func ?= (proxy: NSUserDefaults.Proxy, expr: @autoclosure () -> Any) {
    if !proxy.defaults.hasKey(proxy.key) {
        proxy.defaults[proxy.key] = expr()
    }
}

/// Global shortcut for NSUserDefaults.standardUserDefaults()

let Defaults = NSUserDefaults.standardUserDefaults()
