//
//  SwiftyUserDefaultsTests.swift
//  SwiftyUserDefaultsTests
//
//  Created by Radoslaw Szeja on 09/06/15.
//  Copyright (c) 2015 radex. All rights reserved.
//

import XCTest

class SwiftyUserDefaultsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        clearUserDefaults()
    }
    
    override func tearDown() {
        clearUserDefaults()
        super.tearDown()
    }
    
    func clearUserDefaults() {
        for (key, _) in Defaults.dictionaryRepresentation() {
            Defaults.removeObjectForKey(key as! String)
        }
    }
    
    func testUserDefaultsAssertions() {
        
        // Return nil if doesn't exist
        XCTAssert(Defaults["none"].string == nil)
        XCTAssert(Defaults["none"].int == nil)
        XCTAssert(Defaults["none"].double == nil)
        XCTAssert(Defaults["none"].bool == nil)
        
        // Setting and reading
        Defaults["string1"] = "foo"
        XCTAssert(Defaults["string1"].string == "foo")
        XCTAssert(Defaults["string1"].int == nil)
        XCTAssert(Defaults["string1"].double == nil)
        XCTAssert(Defaults["string1"].bool == nil)
        
        Defaults["int1"] = 100
        XCTAssert(Defaults["int1"].string == "100")
        XCTAssert(Defaults["int1"].int == 100)
        XCTAssert(Defaults["int1"].double == 100)
        XCTAssert(Defaults["int1"].bool == true)
        
        Defaults["double1"] = 3.14
        XCTAssert(Defaults["double1"].string == "3.14")
        XCTAssert(Defaults["double1"].int == 3)
        XCTAssert(Defaults["double1"].double == 3.14)
        XCTAssert(Defaults["double1"].bool == true)
        
        Defaults["bool1"] = true
        XCTAssert(Defaults["bool1"].string == "1")
        XCTAssert(Defaults["bool1"].int == 1)
        XCTAssert(Defaults["bool1"].double == 1.0)
        XCTAssert(Defaults["bool1"].bool == true)
        
        Defaults["bool1"] = false
        XCTAssert(Defaults["bool1"].string == "0")
        XCTAssert(Defaults["bool1"].int == 0)
        XCTAssert(Defaults["bool1"].double == 0.0)
        XCTAssert(Defaults["bool1"].bool == false)
        
        // Object types
        let data = "foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        Defaults["data1"] = data
        XCTAssert(Defaults["data1"].data == data)
        
        let date = NSDate()
        Defaults["date1"] = date
        XCTAssert(Defaults["date1"].date == date)
        
        let array = [1, 2, "foo", true]
        Defaults["array1"] = array
        XCTAssert(Defaults["array1"].array == array)
        XCTAssert(Defaults["array1"].array![2] as! String == "foo")
        
        let dict = ["foo": 1, "bar": [1, 2, 3]]
        Defaults["dict1"] = dict
        XCTAssert(Defaults["dict1"].dictionary == dict)
        
        // +=
        Defaults["int2"] = 5
        Defaults["int2"] += 2
        XCTAssert(Defaults["int2"].int == 7)
        
        Defaults["int3"] += 2
        XCTAssert(Defaults["int3"].int == 2)
        
        Defaults["int4"] = "NaN"
        Defaults["int4"] += 2
        XCTAssert(Defaults["int4"].int == 2)
        
        Defaults["double1"] += 1.5
        XCTAssert(Int(Defaults["double1"].double! * 100.0) == 464)
        
        Defaults["double2"] = 3.14
        Defaults["double2"] += 1
        XCTAssert(Defaults["double2"].double == 4.0)
        
        // ++
        Defaults["int2"]++
        Defaults["int2"]++
        XCTAssert(Defaults["int2"].int == 9)
        
        Defaults["int5"]++
        XCTAssert(Defaults["int5"].int == 1)
        
        // Check if exist
        XCTAssert(!Defaults.hasKey("none"))
        XCTAssert(Defaults.hasKey("string1"))
        XCTAssert(Defaults.hasKey("bool1"))
        
        // Conditional assignment
        Defaults["string1"] ?= "bar"
        XCTAssert(Defaults["string1"].string == "foo")
        
        Defaults["string2"] ?= "bar"
        XCTAssert(Defaults["string2"].string == "bar")
        Defaults["string2"] ?= "baz"
        XCTAssert(Defaults["string2"].string == "bar")
        
        // Removing
        Defaults.remove("string1")
        XCTAssert(!Defaults.hasKey("string1"))
        
        Defaults["string2"] = nil
        XCTAssert(!Defaults.hasKey("string2"))
        
        XCTAssert(true, "Pass")
    }
}
