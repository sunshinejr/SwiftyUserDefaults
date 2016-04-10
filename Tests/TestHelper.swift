#if os(OSX)
    import Cocoa
#else
    import UIKit
    typealias NSColor = UIColor
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

enum TestEnum: String {
    case A, B, C
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<TestEnum?>) -> TestEnum? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<TestEnum>) -> TestEnum {
        get { return unarchive(key) ?? .A }
        set { archive(key, newValue) }
    }
}

enum TestEnum2: Int {
    case Ten = 10
    case Twenty = 20
    case Thirty = 30
}

extension NSUserDefaults {
    subscript(key: DefaultsKey<TestEnum2?>) -> TestEnum2? {
        get { return unarchive(key) }
        set { archive(key, newValue) }
    }
}