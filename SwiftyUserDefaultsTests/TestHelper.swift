#if os(iOS)
    import UIKit
    typealias NSColor = UIColor
#elseif os(OSX)
    import Cocoa
#endif

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