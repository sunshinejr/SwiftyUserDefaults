import Cocoa
import SwiftyUserDefaults

extension NSUserDefaults {
    subscript(key: DefaultsKey<NSColor?>) -> NSColor? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<NSColor>) -> NSColor {
        get { return unarchive(key) ?? .whiteColor() }
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<[NSColor]>) -> [NSColor] {
        get { return unarchive(key) ?? [] }
        set { archive(key, newValue) }
    }
}