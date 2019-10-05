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
    var keyStore: FrogKeyStore<Serializable> { get }
}

extension DefaultsSerializableSpec where Serializable.T: Equatable, Serializable.T == Serializable, Serializable.ArrayBridge.T == [Serializable.T] {

    func testValues() {
        when("key-default value") {
            var defaults: DefaultsAdapter<FrogKeyStore<Serializable>>!
            var removeObject: ((String) -> Void)!

            beforeEach {
                let userDefaults = UserDefaults(suiteName: UUID().uuidString)!
                defaults = DefaultsAdapter(defaults: userDefaults,
                                           keyStore: self.keyStore)
                userDefaults.cleanObjects()
                removeObject = userDefaults.removeObject
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

                expect(defaults[key: key]) == self.defaultValue
            }

            #if swift(>=5.1)
            then("get a default value with dynamicMemberLookup") {
                self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                expect(defaults.testValue) == self.defaultValue
            }
            #endif

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])

                expect(defaults[key: key]) == [self.defaultValue]
            }

            #if swift(>=5.1)
            then("get a default array value with dynamicMemberLookup") {
                self.keyStore.testArray = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])

                expect(defaults.testArray) == [self.defaultValue]
            }
            #endif

            then("save a value") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save a value with dynamicMemberLookup") {
                self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults.testValue = expectedValue

                expect(defaults.testValue) == expectedValue
            }
            #endif

            then("save an array value") {
                let key = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save an array value with dynamicMemberLookup") {
                self.keyStore.testArray = DefaultsKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults.testArray = expectedValue

                expect(defaults.testArray) == expectedValue
            }
            #endif

            then("remove a value") {
                let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                defaults[key: key] = self.customValue

                removeObject("test")

                expect(defaults[key: key]) == self.defaultValue
            }

            #if swift(>=5.1)
            then("remove a value with dynamicMemberLookup") {
                self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                defaults.testValue = self.customValue

                removeObject("test")

                expect(defaults.hasKey(\.testValue)) == false
                expect(defaults.testValue) == self.defaultValue
            }
            #endif

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                defaults[key: key] = [self.customValue]

                removeObject("test")

                expect(defaults[key: key]) == [self.defaultValue]
            }

            #if swift(>=5.1)
            then("remove an array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                defaults.testOptionalArray = [self.customValue]

                defaults.remove(\.testOptionalArray)

                expect(defaults.hasKey(\.testOptionalArray)) == false
                expect(defaults.testOptionalArray) == [self.defaultValue]
            }
            #endif
        }
    }

    func testOptionalValues() {
        when("key-default optional value") {
            var defaults: DefaultsAdapter<FrogKeyStore<Serializable>>!

            beforeEach {
                let userDefaults = UserDefaults()
                defaults = DefaultsAdapter(defaults: userDefaults,
                                           keyStore: self.keyStore)
                userDefaults.cleanObjects()
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

                expect(defaults[key: key]) == self.defaultValue
            }

            #if swift(>=5.1)
            then("get a default value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                expect(defaults.testOptionalValue) == self.defaultValue
            }
            #endif

            then("get a default array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])

                expect(defaults[key: key]) == [self.defaultValue]
            }

            #if swift(>=5.1)
            then("get a default array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])

                expect(defaults.testOptionalArray) == [self.defaultValue]
            }
            #endif

            then("save a value") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save a value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults.testOptionalValue = expectedValue

                expect(defaults.testOptionalValue) == expectedValue
            }
            #endif

            then("save an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save an array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults.testOptionalArray = expectedValue

                expect(defaults.testOptionalArray) == expectedValue
            }
            #endif

            then("remove a value") {
                let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                defaults[key: key] = nil

                expect(defaults[key: key]) == self.defaultValue
            }

            #if swift(>=5.1)
            then("remove a value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                defaults.testOptionalValue = nil

                expect(defaults.testOptionalValue) == self.defaultValue
            }
            #endif

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])

                defaults[key: key] = nil

                expect(defaults[key: key]) == [self.defaultValue]
            }

            #if swift(>=5.1)
            then("remove an array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test", defaultValue: [self.defaultValue])

                defaults.testOptionalArray = nil

                expect(defaults.testOptionalArray) == [self.defaultValue]
            }
            #endif
        }
    }

    func testOptionalValuesWithoutDefaultValue() {
        when("key-nil optional value") {
            var defaults: DefaultsAdapter<FrogKeyStore<Serializable>>!

            beforeEach {
                let userDefaults = UserDefaults()
                defaults = DefaultsAdapter(defaults: userDefaults,
                                           keyStore: self.keyStore)
                userDefaults.cleanObjects()
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
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save a value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")
                let expectedValue = self.customValue
                defaults.testOptionalValue = expectedValue

                expect(defaults.testOptionalValue) == expectedValue
            }
            #endif

            then("save an array value") {
                let key = DefaultsKey<[Serializable]?>("test")
                let expectedValue = [self.customValue]
                defaults[key: key] = expectedValue

                expect(defaults[key: key]) == expectedValue
            }

            #if swift(>=5.1)
            then("save an array value with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test")
                let expectedValue = [self.customValue]
                defaults.testOptionalArray = expectedValue

                expect(defaults.testOptionalArray) == expectedValue
            }
            #endif

            then("remove a value") {
                let key = DefaultsKey<Serializable?>("test")

                defaults[key: key] = self.defaultValue
                expect(defaults[key: key]) == self.defaultValue

                defaults[key: key] = nil
                expect(defaults[key: key]).to(beNil())
            }

            #if swift(>=5.1)
            then("remove a value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")

                defaults.testOptionalValue = self.defaultValue
                expect(defaults.testOptionalValue) == self.defaultValue

                defaults.testOptionalValue = nil
                expect(defaults.testOptionalValue).to(beNil())
            }
            #endif

            then("remove an array value") {
                let key = DefaultsKey<[Serializable]?>("test")

                defaults[key: key] = [self.defaultValue]
                expect(defaults[key: key]) == [self.defaultValue]

                defaults[key: key] = nil
                expect(defaults[key: key]).to(beNil())
            }

            #if swift(>=5.1)
            then("remove an array with dynamicMemberLookup") {
                self.keyStore.testOptionalArray = DefaultsKey<[Serializable]?>("test")

                defaults.testOptionalArray = [self.defaultValue]
                expect(defaults.testOptionalArray) == [self.defaultValue]

                defaults.testOptionalArray = nil
                expect(defaults.testOptionalArray).to(beNil())
            }
            #endif

            then("compare optional value to non-optional value") {
                let key = DefaultsKey<Serializable?>("test")
                expect(defaults[key: key] == nil).to(beTrue())
                expect(defaults[key: key] != self.defaultValue).to(beTrue())
            }

            #if swift(>=5.1)
            then("compare optional value to non-optional value with dynamicMemberLookup") {
                self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")
                expect(defaults.testOptionalValue == nil).to(beTrue())
                expect(defaults.testOptionalValue != self.defaultValue).to(beTrue())
            }
            #endif
        }
    }

    func testPlistRegisteringValues(valueStrings: [String: Serializable?]) {
        let keyPrefix = "argumentToInject"
        let enumeratedArguments = valueStrings.enumerated()

        given("plist-registered values") {
            var defaults: DefaultsAdapter<FrogKeyStore<Serializable>>!

            beforeEach {
                let suiteName = UUID().uuidString
                let userDefaults = UserDefaults(suiteName: suiteName)!
                defaults = DefaultsAdapter(defaults: userDefaults,
                                           keyStore: self.keyStore)
                injectPlistArguments(to: userDefaults)
            }

            then("read values to non-optional keys") {
                precondition(!valueStrings.isEmpty, "`valueStrings` cannot be empty as we need strings:values to test fetching them from plist")

                for (key, value) in transformToProperKeyValue() {
                    let (stringValue, expectedParsedValue) = value
                    let defaultsKey = DefaultsKey<Serializable>(key, defaultValue: self.defaultValue)
                    precondition(defaults.hasKey(defaultsKey), "UserDefaults didn't pick up the process arguments")

                    let expectedValue = expectedParsedValue ?? self.defaultValue
                    expect(defaults[key: defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
                }
            }

            then("read values to optional keys") {
                precondition(!valueStrings.isEmpty, "`valueStrings` cannot be empty as we need strings:values to test fetching them from plist")

                for (key, value) in transformToProperKeyValue() {
                    let (stringValue, expectedParsedValue) = value
                    let defaultsKey = DefaultsKey<Serializable?>(key)
                    precondition(defaults.hasKey(defaultsKey), "UserDefaults didn't pick up the process arguments")

                    if let expectedValue = expectedParsedValue {
                        expect(defaults[key: defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
                    } else {
                        expect(defaults[key: defaultsKey]).to(beNil(), description: "key: \(key), stringValue: \(stringValue)")
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
                    expect(defaults[key: defaultsKey]).to(equal(expectedValue), description: "key: \(key), stringValue: \(stringValue)")
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
            var defaults: DefaultsAdapter<FrogKeyStore<Serializable>>!

            beforeEach {
                let suiteName = UUID().uuidString
                let userDefaults = UserDefaults(suiteName: suiteName)!
                defaults = DefaultsAdapter(defaults: userDefaults,
                                           keyStore: self.keyStore)
            }

            when("optional key without default value") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                #if swift(>=5.1)
                then("receive updates with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults.testOptionalValue = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }
                #endif

                then("receives initial update being nil") {
                    let key = DefaultsKey<Serializable?>("test1")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                then("receives initial update being non-nil") {
                    let key = DefaultsKey<Serializable?>("test1")
                    defaults[key: key] = self.customValue

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update being nil with keyPaths") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test2")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                then("receives initial update being non-nil with keyPaths") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test2")
                    defaults[\.testOptionalValue] = self.customValue

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives nil update") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults[key: key] = self.defaultValue
                    defaults[key: key] = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(beNil())
                }

                #if swift(>=5.1)
                then("receives nil update with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults.testOptionalValue = self.defaultValue
                    defaults.testOptionalValue = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(beNil())
                }
                #endif

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                #if swift(>=5.1)
                then("remove observer on dispose with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test")

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults.testOptionalValue = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
                #endif
            }

            when("optional key with default value") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                #if swift(>=5.1)
                then("receive updates with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults.testOptionalValue = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }
                #endif

                then("receives initial update being default value") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("receives initial update being custom value") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                    defaults[key: key] = self.customValue

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update being default value with keyPaths") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("receives initial update being custom value with keyPaths") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)
                    defaults[\.testOptionalValue] = self.customValue

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives nil update") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults[key: key] = self.defaultValue
                    defaults[key: key] = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                #if swift(>=5.1)
                then("receives nil update with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }
                    defaults.testOptionalValue = self.customValue
                    defaults.testOptionalValue = nil

                    expect(update).toEventuallyNot(beNil())
                    expect(update?.oldValue).toEventually(equal(self.customValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }
                #endif

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                #if swift(>=5.1)
                then("remove observer on dispose with dynamicMemberLookup") {
                    self.keyStore.testOptionalValue = DefaultsKey<Serializable?>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable?>.Update?
                    let observer = defaults.observe(\.testOptionalValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults.testOptionalValue = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
                #endif
            }

            when("non-optional key") {
                then("receive updates") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                #if swift(>=5.1)
                then("receive updates with dynamicMemberLookup") {
                    self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(\.testValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    defaults.testValue = self.customValue

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }
                #endif

                then("receives initial update being default value") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("receives initial update being custom value") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                    defaults[key: key] = self.customValue

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("receives initial update being default value with keyPaths") {
                    self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(\.testValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.defaultValue))
                }

                then("receives initial update being custom value with keyPaths") {
                    self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)
                    defaults[\.testValue] = self.customValue

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(\.testValue, options: [.initial, .old, .new]) { receivedUpdate in
                        update = receivedUpdate
                    }

                    expect(update?.oldValue).toEventually(equal(self.defaultValue))
                    expect(update?.newValue).toEventually(equal(self.customValue))
                }

                then("remove observer on dispose") {
                    let key = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(key) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults[key: key] = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }

                #if swift(>=5.1)
                then("remove observer on dispose with dynamicMemberLookup") {
                    self.keyStore.testValue = DefaultsKey<Serializable>("test", defaultValue: self.defaultValue)

                    var update: DefaultsObserver<Serializable>.Update?
                    let observer = defaults.observe(\.testValue) { receivedUpdate in
                        update = receivedUpdate
                    }

                    observer.dispose()
                    defaults.testValue = self.customValue

                    expect(update?.oldValue).toEventually(beNil())
                    expect(update?.newValue).toEventually(beNil())
                }
                #endif
            }
        }
        #endif
    }
}
