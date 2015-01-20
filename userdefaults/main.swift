import Foundation

extension NSUserDefaults {
    class Proxy {
        private let defaults: NSUserDefaults
        private let key: String
        
        private init(_ defaults: NSUserDefaults, _ key: String) {
            self.defaults = defaults
            self.key = key
        }
        
        /// Returns `true` if key exists
        
        var exists: Bool {
            return defaults.exists(key)
        }
        
        /// Removes key
        
        func remove() {
            defaults.removeObjectForKey(key)
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
    
    func exists(key: String) -> Bool {
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
    assignment
}

/// If key doesn't exist, sets its value to `expr`
/// Note: This isn't the same as `Defaults.registerDefaults`. This method saves the new value to disk, whereas `registerDefaults` only modifies the defaults in memory.
/// Note: If key already exists, the expression after ?= isn't evaluated

func ?= (proxy: NSUserDefaults.Proxy, expr: @autoclosure () -> Any) {
    if !proxy.exists {
        proxy.defaults[proxy.key] = expr()
    }
}

/// Global shortcut for NSUserDefaults.standardUserDefaults()

let Defaults = NSUserDefaults.standardUserDefaults()

//---------------------------------------------------

// Clear defaults before testing

for (key, _) in Defaults.dictionaryRepresentation() {
    Defaults.removeObjectForKey(key as String)
}

// Return nil if doesn't exist
assert(Defaults["none"].string == nil)
assert(Defaults["none"].int == nil)
assert(Defaults["none"].double == nil)
assert(Defaults["none"].bool == nil)

// Setting and reading
Defaults["string1"] = "foo"
assert(Defaults["string1"].string == "foo")
assert(Defaults["string1"].int == nil)
assert(Defaults["string1"].double == nil)
assert(Defaults["string1"].bool == nil)

Defaults["int1"] = 100
assert(Defaults["int1"].string == "100")
assert(Defaults["int1"].int == 100)
assert(Defaults["int1"].double == 100)
assert(Defaults["int1"].bool == true)

Defaults["double1"] = 3.14
assert(Defaults["double1"].string == "3.14")
assert(Defaults["double1"].int == 3)
assert(Defaults["double1"].double == 3.14)
assert(Defaults["double1"].bool == true)

Defaults["bool1"] = true
assert(Defaults["bool1"].string == "1")
assert(Defaults["bool1"].int == 1)
assert(Defaults["bool1"].double == 1.0)
assert(Defaults["bool1"].bool == true)

Defaults["bool1"] = false
assert(Defaults["bool1"].string == "0")
assert(Defaults["bool1"].int == 0)
assert(Defaults["bool1"].double == 0.0)
assert(Defaults["bool1"].bool == false)

// Object types
let data = "foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
Defaults["data1"] = data
assert(Defaults["data1"].data == data)

let date = NSDate()
Defaults["date1"] = date
assert(Defaults["date1"].date == date)

let array = [1, 2, "foo", true]
Defaults["array1"] = array
assert(Defaults["array1"].array == array)
assert(Defaults["array1"].array![2] as String == "foo")

let dict = ["foo": 1, "bar": [1, 2, 3]]
Defaults["dict1"] = dict
assert(Defaults["dict1"].dictionary == dict)

// Check if exist
assert(!Defaults.exists("none"))
assert(!Defaults["none"].exists)

assert(Defaults.exists("string1"))
assert(Defaults.exists("bool1"))
assert(Defaults["string1"].exists)
assert(Defaults["bool1"].exists)

// Conditional assignment
Defaults["string1"] ?= "bar"
assert(Defaults["string1"].string == "foo")

Defaults["string2"] ?= "bar"
assert(Defaults["string2"].string == "bar")
Defaults["string2"] ?= "baz"
assert(Defaults["string2"].string == "bar")

// Removing
Defaults.remove("string1")
assert(!Defaults["string1"].exists)

Defaults["string2"].remove()
assert(!Defaults["string2"].exists)

Defaults["array1"] = nil
assert(!Defaults["array1"].exists)

println("All tests passed")