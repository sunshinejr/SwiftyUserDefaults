//
// SwiftyUserDefaults
//
// Copyright (c) 2015-present Radosław Pietruszewski, Łukasz Mróz
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

    var defaultValue: Serializable.T { get }
    var customValue: Serializable.T { get }
}

extension DefaultsSerializableSpec where Serializable.T: Equatable, Serializable.T == Serializable {

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

    func testOptionalValuesWithoutDefaultValue() {
        when("key-nil optional value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key") {
                let key = DefaultsKey<Serializable?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("create an array key") {
                let key = DefaultsKey<[Serializable]?>("test")
                expect(key._key) == "test"
                expect(key.defaultValue).to(beNil())
            }

            then("save a value") {
                let key = DefaultsKey<Serializable?>("test")
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save an array value") {
                let key = DefaultsKey<[Serializable]?>("test")
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("remove a value") {
                let key = DefaultsKey<Serializable?>("test")

                defaults[key] = self.defaultValue
                expect(defaults[key]) == self.defaultValue

                defaults[key] = nil
                expect(defaults[key]).to(beNil())
            }

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test")

                defaults[key] = [self.defaultValue]
                expect(defaults[key]) == [self.defaultValue]

                defaults[key] = nil
                expect(defaults[key]).to(beNil())
            }

            then("compare optional value to non-optional value") {
                let key = DefaultsKey<Serializable?>("test")
                expect(defaults[key] == nil).to(beTrue())
                expect(defaults[key] != self.defaultValue).to(beTrue())
            }
        }
    }

    func testPlistRegisteringValues(valueStrings: [String: Serializable?]) {
        let keyPrefix = "argumentToInject"
        let enumeratedArguments = valueStrings.enumerated()

        given("plist-registered values") {
            var defaults: UserDefaults!

            beforeEach {
                let suiteName = UUID().uuidString
                defaults = UserDefaults(suiteName: suiteName)
                injectPlistArguments(to: defaults)
            }

            then("read values to non-optional keys") {
                precondition(!valueStrings.isEmpty, "`valueStrings` cannot be empty as we need strings:values to test fetching them from plist")

                for (key, value) in transformToProperKeyValue() {
                    let (stringValue, expectedParsedValue) = value
                    let defaultsKey = DefaultsKey<Serializable>(key, defaultValue: self.defaultValue)
                    precondition(defaults.hasKey(defaultsKey), "UserDefaults didn't pick up the process arguments")

                    let expectedValue = expectedParsedValue ?? self.defaultValue
                    expect(defaults[defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
                }
            }

            then("read values to optional keys") {
                precondition(!valueStrings.isEmpty, "`valueStrings` cannot be empty as we need strings:values to test fetching them from plist")

                for (key, value) in transformToProperKeyValue() {
                    let (stringValue, expectedParsedValue) = value
                    let defaultsKey = DefaultsKey<Serializable?>(key)
                    precondition(defaults.hasKey(defaultsKey), "UserDefaults didn't pick up the process arguments")

                    if let expectedValue = expectedParsedValue {
                        expect(defaults[defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
                    } else {
                        expect(defaults[defaultsKey]).to(beNil(), description: "key: \(key), stringValue: \(stringValue)")
                    }
                }
            }

            then("read values to optional keys with default values") {
                precondition(!valueStrings.isEmpty, "`valueStrings` cannot be empty as we need strings:values to test fetching them from plist")

                for (key, value) in transformToProperKeyValue() {
                    let (stringValue, expectedParsedValue) = value
                    let defaultsKey = DefaultsKey<Serializable?>(key, defaultValue: self.defaultValue)
                    precondition(defaults.hasKey(defaultsKey), "UserDefaults didn't pick up the process arguments")

                    let expectedValue = expectedParsedValue ?? self.defaultValue
                    expect(defaults[defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
                }
            }
        }

        func injectPlistArguments(to userDefaults: UserDefaults) {
            let arguments = transformToProperKeyValue()
                .reduce(into: [String]()) { (result, element) in
                    let (key, value) = element
                    let (stringValue, _) = value
                    result.append(contentsOf: ["-" + key, stringValue])
            }
            let parsedArguments = UserDefaults._parseArguments(arguments)

            userDefaults.setVolatileDomain(parsedArguments, forName: "NSArgumentDomain")
        }

        // Because we accept a dictionary that contains [stringValue: expected parsedValue]
        // this function transforms it to a [defaultsKey: (stringValue, expectedParsedValue)]
        func transformToProperKeyValue() -> [String: (String, Serializable?)] {
            return enumeratedArguments
                .reduce(into: [String: (String, Serializable?)]()) { (result, enumeratedElement) in
                    let (index, element) = enumeratedElement
                    let (value, expectedParsedValue) = element
                    let argumentKey = "\(keyPrefix)\(index)"
                    result[argumentKey] = (value, expectedParsedValue)
            }
        }
    }

    func testObserving() {
        #if !os(Linux)
        given("key-value observing") {
            var defaults: UserDefaults!

            beforeEach {
                let suiteName = UUID().uuidString
                defaults = UserDefaults(suiteName: suiteName)
            }

            when("optional key without default value") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                then("receives nil update") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults[key] = self.defaultValue
                    defaults[key] = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(beNil())
                }

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
            }

            when("optional key with default value") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("receives nil update") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults[key] = self.defaultValue
                    defaults[key] = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
            }

            when("non-optional key") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key: key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key: key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
            }
        }
        #endif
    }
}
