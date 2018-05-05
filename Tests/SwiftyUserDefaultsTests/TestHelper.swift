import Foundation
import Quick
import SwiftyUserDefaults

func given(_ description: String, closure: @escaping () -> ()) {
    describe(description, closure)
}

func when(_ description: String, closure: @escaping () -> ()) {
    context(description, closure)
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

struct FrogCodable: Codable {

    let name: String

    init(name: String = "Froggy") {
        self.name = name
    }
}

final class FrogSerializable: NSObject, NSCoding, DefaultsSerializable {

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
