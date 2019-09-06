import Foundation
import Quick
import SwiftyUserDefaults

func given(_ description: String, closure: @escaping () -> Void) {
    describe(description, closure: closure)
}

func when(_ description: String, closure: @escaping () -> Void) {
    context(description, closure: closure)
}

func then(_ description: String, closure: @escaping () -> Void) {
    it(description, closure: closure)
}

extension UserDefaults {

    func cleanObjects() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
}

struct FrogCodable: Codable, Equatable, DefaultsSerializable {

    let name: String

    init(name: String = "Froggy") {
        self.name = name
    }
}

final class FrogSerializable: NSObject, DefaultsSerializable, NSCoding {

    typealias T = FrogSerializable

    let name: String

    init(name: String = "Froggy") {
        self.name = name
    }

    init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: "name") as? String else { return nil }

        self.name = name
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? FrogSerializable else { return false }

        return name == rhs.name
    }
}

enum BestFroggiesEnum: String, DefaultsSerializable {

    case Andy
    case Dandy
}

final class DefaultsFrogBridge: DefaultsBridge {
    func get(key: String, userDefaults: UserDefaults) -> FrogCustomSerializable? {
        let name = userDefaults.string(forKey: key)
        return name.map(FrogCustomSerializable.init)
    }

    func save(key: String, value: FrogCustomSerializable?, userDefaults: UserDefaults) {
        userDefaults.set(value?.name, forKey: key)
    }

    func deserialize(_ object: Any) -> FrogCustomSerializable? {
        guard let name = object as? String else { return nil }

        return FrogCustomSerializable(name: name)
    }
}

final class DefaultsFrogArrayBridge: DefaultsBridge {
    func get(key: String, userDefaults: UserDefaults) -> [FrogCustomSerializable]? {
        return userDefaults.array(forKey: key)?
            .compactMap { $0 as? String }
            .map(FrogCustomSerializable.init)
    }

    func save(key: String, value: [FrogCustomSerializable]?, userDefaults: UserDefaults) {
        let values = value?.map { $0.name }
        userDefaults.set(values, forKey: key)
    }

    func deserialize(_ object: Any) -> [FrogCustomSerializable]? {
        guard let names = object as? [String] else { return nil }

        return names.map(FrogCustomSerializable.init)
    }
}

struct FrogCustomSerializable: DefaultsSerializable, Equatable {

    static var _defaults: DefaultsFrogBridge { return DefaultsFrogBridge() }
    static var _defaultsArray: DefaultsFrogArrayBridge { return DefaultsFrogArrayBridge() }

    let name: String
}

final class FrogKeyStore<Serializable: DefaultsSerializable & Equatable>: DefaultsKeyStore {

    lazy var testValue: DefaultsKey<Serializable> = { fatalError("not initialized yet") }()
    lazy var testArray: DefaultsKey<[Serializable]> = { fatalError("not initialized yet") }()
    lazy var testOptionalValue: DefaultsKey<Serializable?> = { fatalError("not initialized yet") }()
    lazy var testOptionalArray: DefaultsKey<[Serializable]?> = { fatalError("not initialized yet") }()
}
