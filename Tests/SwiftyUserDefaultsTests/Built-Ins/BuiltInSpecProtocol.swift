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

import Quick
import Nimble
@testable import SwiftyUserDefaults

protocol BuiltInSpec {
    associatedtype BuiltIn: DefaultsSerializable & Equatable

    var defaultValue: BuiltIn { get }
    var customValue: BuiltIn { get }
}

extension BuiltInSpec where BuiltIn: DefaultsDefaultValueType {

    func testDefaultValues() {
        var defaults: UserDefaults!

        beforeEach {
            defaults = UserDefaults()
            defaults.cleanObjects()
        }

        when("type-default value") {
            then("create a key") {
                let key = DefaultsKey<BuiltIn>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == BuiltIn.defaultValue
            }

            then("get a default value") {
                let key = DefaultsKey<BuiltIn>("test")
                let value = defaults[key]
                expect(value) == BuiltIn.defaultValue
            }

            then("save a value") {
                let key = DefaultsKey<BuiltIn>("test")
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}

extension BuiltInSpec where BuiltIn: DefaultsDefaultArrayValueType {

    func testDefaultArrayValues() {
        when("array-type-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create an array key") {
                let key = DefaultsKey<[BuiltIn]>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == BuiltIn.defaultArrayValue
            }

            then("get a default array value") {
                let key = DefaultsKey<[BuiltIn]>("test")
                let value = defaults[key]
                expect(value) == BuiltIn.defaultArrayValue
            }

            then("save an array value") {
                let key = DefaultsKey<[BuiltIn]>("test")
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}

extension BuiltInSpec {

    func testValues() {
        when("key-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key") {
                let key = DefaultsKey<BuiltIn>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }

            then("create an array key") {
                let key = DefaultsKey<[BuiltIn]>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }

            then("get a default value") {
                let key = DefaultsKey<BuiltIn>("test", defaultValue: self.defaultValue)
                let value = defaults[key]
                expect(value) == self.defaultValue
            }

            then("get a default array value") {
                let key = DefaultsKey<[BuiltIn]>("test", defaultValue: [self.defaultValue])
                let value = defaults[key]
                expect(value) == [self.defaultValue]
            }

            then("save a value") {
                let key = DefaultsKey<BuiltIn>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save an array value") {
                let key = DefaultsKey<[BuiltIn]>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}
