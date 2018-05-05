import Quick
import Nimble
@testable import SwiftyUserDefaults

protocol CodableSpec {
    associatedtype Serializable: Codable & Equatable

    var defaultValue: Serializable { get }
    var customValue: Serializable { get }
}

extension CodableSpec where Serializable: DefaultsDefaultValueType {

    func testDefaultValues() {
        var defaults: UserDefaults!

        beforeEach {
            defaults = UserDefaults()
            defaults.cleanObjects()
        }

        when("type-default value") {
            then("create a key") {
                let key = DefaultsCodableKey<Serializable>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == Serializable.defaultValue
            }

            then("get a default value") {
                let key = DefaultsCodableKey<Serializable>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultValue
            }

            then("save a value") {
                let key = DefaultsCodableKey<Serializable>("test")
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}

extension CodableSpec where Serializable: DefaultsDefaultArrayValueType {

    func testDefaultArrayValues() {
        when("array-type-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create an array key") {
                let key = DefaultsCodableKey<[Serializable]>("test")
                expect(key._key) == "test"
                expect(key.defaultValue) == Serializable.defaultArrayValue
            }

            then("get a default array value") {
                let key = DefaultsCodableKey<[Serializable]>("test")
                let value = defaults[key]
                expect(value) == Serializable.defaultArrayValue
            }

            then("save an array value") {
                let key = DefaultsCodableKey<[Serializable]>("test")
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}

extension CodableSpec {

    func testValues() {
        when("key-default value") {
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaults()
                defaults.cleanObjects()
            }

            then("create a key") {
                let key = DefaultsCodableKey<Serializable>("test", defaultValue: self.defaultValue)
                expect(key._key) == "test"
                expect(key.defaultValue) == self.defaultValue
            }

            then("create an array key") {
                let key = DefaultsCodableKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                expect(key._key) == "test"
                expect(key.defaultValue) == [self.defaultValue]
            }

            then("get a default value") {
                let key = DefaultsCodableKey<Serializable>("test", defaultValue: self.defaultValue)
                let value = defaults[key]
                expect(value) == self.defaultValue
            }

            then("get a default array value") {
                let key = DefaultsCodableKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let value = defaults[key]
                expect(value) == [self.defaultValue]
            }

            then("save a value") {
                let key = DefaultsCodableKey<Serializable>("test", defaultValue: self.defaultValue)
                let expectedValue = self.customValue
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }

            then("save an array value") {
                let key = DefaultsCodableKey<[Serializable]>("test", defaultValue: [self.defaultValue])
                let expectedValue = [self.customValue]
                defaults[key] = expectedValue

                let value = defaults[key]

                expect(value) == expectedValue
            }
        }
    }
}
