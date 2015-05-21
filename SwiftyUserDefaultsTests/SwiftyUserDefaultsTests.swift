//
//  SwiftyUserDefaultsTests.swift
//  SwiftyUserDefaultsTests
//
//  Created by Alexey Poimtsev on 21/05/15.
//
//

import UIKit
import XCTest
import SwiftyUserDefaults

class SwiftyUserDefaultsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Clear defaults before testing
        
        for (key, _) in Defaults.dictionaryRepresentation() {
            Defaults.removeObjectForKey(key as! String)
        }
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFramework() {

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
        assert(Defaults["array1"].array![2] as! String == "foo")
        
        let dict = ["foo": 1, "bar": [1, 2, 3]]
        Defaults["dict1"] = dict
        assert(Defaults["dict1"].dictionary == dict)
        
        // +=
        Defaults["int2"] = 5
        Defaults["int2"] += 2
        assert(Defaults["int2"].int == 7)
        
        Defaults["int3"] += 2
        assert(Defaults["int3"].int == 2)
        
        Defaults["int4"] = "NaN"
        Defaults["int4"] += 2
        assert(Defaults["int4"].int == 2)
        
        Defaults["double1"] += 1.5
        assert(Int(Defaults["double1"].double! * 100.0) == 464)
        
        Defaults["double2"] = 3.14
        Defaults["double2"] += 1
        assert(Defaults["double2"].double == 4.0)
        
        // ++
        Defaults["int2"]++
        Defaults["int2"]++
        assert(Defaults["int2"].int == 9)
        
        Defaults["int5"]++
        assert(Defaults["int5"].int == 1)
        
        // Check if exist
        assert(!Defaults.hasKey("none"))
        assert(Defaults.hasKey("string1"))
        assert(Defaults.hasKey("bool1"))
        
        // Conditional assignment
        Defaults["string1"] ?= "bar"
        assert(Defaults["string1"].string == "foo")
        
        Defaults["string2"] ?= "bar"
        assert(Defaults["string2"].string == "bar")
        Defaults["string2"] ?= "baz"
        assert(Defaults["string2"].string == "bar")
        
        // Removing
        Defaults.remove("string1")
        assert(!Defaults.hasKey("string1"))
        
        Defaults["string2"] = nil
        assert(!Defaults.hasKey("string2"))
        
        println("All tests passed")
        
    }

    
}
