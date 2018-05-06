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

import Foundation
import Quick
import Nimble
@testable import SwiftyUserDefaults

protocol DefaultsSerializableSpec {
    associatedtype Serializable: DefaultsSerializable & Equatable

    var defaultValue: Serializable { get }
    var customValue: Serializable { get }
}

extension DefaultsSerializableSpec where Serializable: DefaultsDefaultValueType {

    func testDefaultValues() {
        var defaults: UserDefaults!

        beforeEach {
            defaults = UserDefaults()
            defaults.cleanObjects()
        }

        when("type-default value") {
            then("create a key") {
                let key = DefaultsKey<Serializable>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("get a default value") {
                let key = DefaultsKey<Serializable>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultValue
            }

            then("save a value") {
                let key = DefaultsKey<Serializable>("test")
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove a value") {
                let key = DefaultsKey<Serializable>("test")

                defaults[key] = self.customValue
                defaults.removeObject(forKey: "test")

                expect(defaults[key]) == Serializable.defaultValue
            }
        }
    }
}

extension DefaultsSerializableSpec where Serializable: DefaultsDefaultArrayValueType {

    func testDefaultArrayValues() {
        when("array-type-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create an array key") {
                let key = DefaultsKey<[Serializable]>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultArrayValue
            }

            then("save an array value") {
                let key = DefaultsKey<[Serializable]>("test")
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]>("test")

                defaults[key] = [self.customValue]
                defaults.removeObject(forKey: "test")

                expect(defaults[key]) == Serializable.defaultArrayValue
            }
        }
    }
}

extension DefaultsSerializableSpec {

    func testValues() {
        when("key-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }

            then("create an array key") {
                let key = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }

            then("get a default value") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                let value = defaults[key]
                expect(value) == self.defaultValue
            }

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let value = defaults[key]
                expect(value) == [self.defaultValue]
            }

            then("save a value") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save an array value") {
                let key = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove a value") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                defaults[key] = self.customValue

                defaults.removeObject(forKey: "test")

                expect(defaults[key]) == self.defaultValue
            }

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                defaults[key] = [self.customValue]

                defaults.removeObject(forKey: "test")

                expect(defaults[key]) == [self.defaultValue]
            }
        }
    }
}

extension DefaultsSerializableSpec {

    func testOptionalValues() {
        when("key-default optional value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }

            then("create an array key") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }

            then("get a default value") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                let value = defaults[key]
                expect(value) == self.defaultValue
            }

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                let value = defaults[key]
                expect(value) == [self.defaultValue]
            }

            then("save a value") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove a value") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                defaults[key] = nil

                expect(defaults[key]) == self.defaultValue
            }

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])

                defaults[key] = nil

                expect(defaults[key]) == [self.defaultValue]
            }
        }
    }
}

extension DefaultsSerializableSpec where Serializable: DefaultsDefaultValueType {

    func testOptionalDefaultValues() {
        var defaults: UserDefaults!

        beforeEach {
            defaults = UserDefaults()
            defaults.cleanObjects()
        }

        when("type-default value") {
            then("create a key") {
                let key = DefaultsKey<Serializable?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("get a default value") {
                let key = DefaultsKey<Serializable?>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultValue
            }

            then("save a value") {
                let key = DefaultsKey<Serializable?>("test")
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove a value") {
                let key = DefaultsKey<Serializable?>("test")

                defaults[key] = nil

                expect(defaults[key]) == Serializable.defaultValue
            }
        }
    }
}

extension DefaultsSerializableSpec where Serializable: DefaultsDefaultArrayValueType {

    func testOptionalDefaultArrayValues() {
        when("array-type-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create an array key") {
                let key = DefaultsKey<[Serializable]?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]?>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultArrayValue
            }

            then("save an array value") {
                let key = DefaultsKey<[Serializable]?>("test")
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test")

                defaults[key] = nil

                expect(defaults[key]) == Serializable.defaultArrayValue
            }
        }
    }
}
