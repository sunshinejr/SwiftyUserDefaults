import Foundation

typealias DefaultsSerializable = DefaultsStoreable & DefaultsGettable

protocol DefaultsStoreable {
    static func save(key: String, value: Self?, userDefaults: UserDefaults)
}

protocol DefaultsGettable {
    static func get(key: String, userDefaults: UserDefaults) -> Self?
}
