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

// TODO: Okay, we cannot possibly copy/paste all these built-in types, maintaining them will be _awful_
final class DefaultsIntSpec: QuickSpec {

    override func spec() {
        var defaults: UserDefaults!

        given("Int") {
            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key without default value") {
                let key = DefaultsKey<Int>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == Int.defaultValue
            }

            then("create an array key without default value") {
                let key = DefaultsKey<[Int]>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == [Int].defaultValue
            }

            then("create a key with default value") {
                let key = DefaultsKey<Int>("test", defaultValue: 2)
                expect(key._key) == "test"
                expect(key.defaultValue) == 2
            }

            then("create an array key with default value") {
                let key = DefaultsKey<[Int]>("test", defaultValue: [1, 2])
                expect(key._key) == "test"
                expect(key.defaultValue) == [1, 2]
            }

            then("get a default value") {
                let key = DefaultsKey<Int>("test")
                let value = defaults[key]
                expect(value) == key.defaultValue
            }

            then("get a custom-default value") {
                let key = DefaultsKey<Int>("test", defaultValue: 3)
                let value = defaults[key]
                expect(value) == 3
            }

            then("save a value") {
                let key = DefaultsKey<Int>("test")
                let expectedValue = 4
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save a value for key with default custom value") {
                let key = DefaultsKey<Int>("test", defaultValue: 6)
                let expectedValue = 5
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}
