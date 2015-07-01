import XCTest
import SwiftyUserDefaults

class SwiftyUserDefaultsTests: XCTestCase {
    
    override func setUp() {
        // clear defaults before testing
        for (key, _) in Defaults.dictionaryRepresentation() {
            Defaults.removeObjectForKey(key as! String)
        }
        super.tearDown()
    }

    func testNone() {
        let key = "none"
        XCTAssertNil(Defaults[key].string)
        XCTAssertNil(Defaults[key].int)
        XCTAssertNil(Defaults[key].double)
        XCTAssertNil(Defaults[key].bool)
        XCTAssertFalse(Defaults.hasKey(key))
        
        //Return default value if doesn't exist
        XCTAssertEqual(Defaults[key].stringValue, "")
        XCTAssertEqual(Defaults[key].intValue, 0)
        XCTAssertEqual(Defaults[key].doubleValue, 0)
        XCTAssertEqual(Defaults[key].boolValue, false)
        XCTAssertEqual(Defaults[key].arrayValue, [])
        XCTAssertEqual(Defaults[key].dictionaryValue, [:])
        XCTAssertEqual(Defaults[key].dataValue, NSData())
    }
    
    func testString() {
        // set and read
        let key = "string"
        Defaults[key] = "foo"
        XCTAssertEqual(Defaults[key].string!, "foo")
        XCTAssertNil(Defaults[key].int)
        XCTAssertNil(Defaults[key].double)
        XCTAssertNil(Defaults[key].bool)
        
        // existance
        XCTAssertTrue(Defaults.hasKey(key))
        
        // ?=
        Defaults[key] ?= "bar"
        XCTAssertEqual(Defaults[key].string!, "foo")
        
        let key2 = "string2"
        Defaults[key2] ?= "bar"
        XCTAssertEqual(Defaults[key2].string!, "bar")
        Defaults[key2] ?= "baz"
        XCTAssertEqual(Defaults[key2].string!, "bar")
        
        // removing
        Defaults.remove(key)
        XCTAssertFalse(Defaults.hasKey(key))
        Defaults[key2] = nil
        XCTAssertFalse(Defaults.hasKey(key2))
    }
    
    func testInt() {
        // set and read
        let key = "int"
        Defaults[key] = 100
        XCTAssertEqual(Defaults[key].string!, "100")
        XCTAssertEqual(Defaults[key].int!,     100)
        XCTAssertEqual(Defaults[key].double!,  100)
        XCTAssertTrue(Defaults[key].bool!)
        
        // +=
        let key2 = "int2"
        Defaults[key2] = 5
        Defaults[key2] += 2
        XCTAssertEqual(Defaults[key2].int!, 7)
        
        let key3 = "int3"
        Defaults[key3] += 2
        XCTAssertEqual(Defaults[key3].int!, 2)
        
        let key4 = "int4"
        Defaults[key4] = "NaN"
        Defaults[key4] += 2
        XCTAssertEqual(Defaults[key4].int!, 2)
        
        // ++
        Defaults[key2]++
        Defaults[key2]++
        XCTAssertEqual(Defaults[key2].int!, 9)
        
        let key5 = "int5"
        Defaults[key5]++
        XCTAssertEqual(Defaults[key5].int!, 1)

    
        // -=
        let key6 = "int6"
        Defaults[key6] = 5
        Defaults[key6] -= 2
        XCTAssertEqual(Defaults[key6].int!, 3)
        
        let key7 = "int7"
        Defaults[key7] -= 2
        XCTAssertEqual(Defaults[key7].int!, -2)
        
        let key8 = "int8"
        Defaults[key8] = "NaN"
        Defaults[key8] -= 2
        XCTAssertEqual(Defaults[key8].int!, -2)
        
        // --
        Defaults[key6]--
        Defaults[key6]--
        XCTAssertEqual(Defaults[key6].int!, 1)
        
        let key9 = "int9"
        Defaults[key9]--
        XCTAssertEqual(Defaults[key9].int!, -1)
}
    
    func testDouble() {
        // set and read
        let key = "double"
        Defaults[key] = 3.14
        XCTAssertEqual(Defaults[key].string!, "3.14")
        XCTAssertEqual(Defaults[key].int!,     3)
        XCTAssertEqual(Defaults[key].double!,  3.14)
        XCTAssertTrue(Defaults[key].bool!)
        
        XCTAssertEqual(Defaults[key].stringValue, "3.14")
        XCTAssertEqual(Defaults[key].intValue, 3)
        XCTAssertEqual(Defaults[key].doubleValue, 3.14)
        XCTAssertEqual(Defaults[key].boolValue, true)
        
        Defaults[key] += 1.5
        XCTAssertEqual(Int(Defaults[key].double! *  100.0), 464)

        let key2 = "double2"
        Defaults[key2] = 3.14
        Defaults[key2] += 1
        XCTAssertEqual(Defaults[key2].double!, 4.0)
        
        let key3 = "double3"
        Defaults[key3] += 5.3
        XCTAssertEqual(Defaults[key3].double!, 5.3)
    }
    
    func testBool() {
        // set and read
        let key = "bool"
        Defaults[key] = true
        XCTAssertEqual(Defaults[key].string!, "1")
        XCTAssertEqual(Defaults[key].int!,     1)
        XCTAssertEqual(Defaults[key].double!,  1.0)
        XCTAssertTrue(Defaults[key].bool!)
        
        Defaults[key] = false
        XCTAssertEqual(Defaults[key].string!, "0")
        XCTAssertEqual(Defaults[key].int!,     0)
        XCTAssertEqual(Defaults[key].double!,  0.0)
        XCTAssertFalse(Defaults[key].bool!)
        
        // existance
        XCTAssertTrue(Defaults.hasKey(key))
    }
    
    func testData() {
        let key = "data"
        let data = "foo".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        Defaults[key] = data
        XCTAssertEqual(Defaults[key].data!, data)
        XCTAssertNil(Defaults[key].string)
        XCTAssertNil(Defaults[key].int)
    }
    
    func testDate() {
        let key = "date"
        let date = NSDate()
        Defaults[key] = date
        XCTAssertEqual(Defaults[key].date!, date)
    }
    
    func testArray() {
        let key = "array"
        let array = [1, 2, "foo", true]
        Defaults[key] = array
        XCTAssertEqual(Defaults[key].array!, array)
        XCTAssertEqual(Defaults[key].array![2] as! String, "foo")
    }
    
    func testDict() {
        let key = "dict"
        let dict = ["foo": 1, "bar": [1, 2, 3]]
        Defaults[key] = dict
        XCTAssertEqual(Defaults[key].dictionary!, dict)
    }
}
