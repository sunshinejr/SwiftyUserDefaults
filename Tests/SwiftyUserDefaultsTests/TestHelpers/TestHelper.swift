import Foundation
import Quick
import SwiftyUserDefaults

func given(_ description: String, closure: @escaping () -> ()) {
    describe(description, closure: closure)
}

func when(_ description: String, closure: @escaping () -> ()) {
    context(description, closure: closure)
}

func then(_ description: String, closure: @escaping () -> ()) {
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

    static var defaults_bridge: DefaultsBridge<FrogSerializable> { return DefaultsKeyedArchiverBridge() }

    static var defaults_arrayBridge: DefaultsBridge<[FrogSerializable]> { return DefaultsKeyedArchiverBridge() }

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
