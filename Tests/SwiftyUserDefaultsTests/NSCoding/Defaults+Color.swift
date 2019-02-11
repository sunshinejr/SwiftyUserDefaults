//
// SwiftyUserDefaults
//
// Copyright (c) 2015-2018 Radosław Pietruszewski, Łukasz Mróz
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

import Quick
import Nimble
import SwiftyUserDefaults

#if canImport(AppKit)
    import AppKit

    extension NSColor: DefaultsSerializable {}

    final class DefaultsUIColorSerializableSpec: QuickSpec, DefaultsSerializableSpec {

        typealias Serializable = NSColor

        var customValue: NSColor = .green
        var defaultValue: NSColor = .blue

        override func spec() {
            given("NSColor") {
                self.testValues()
                self.testOptionalValues()
                self.testOptionalValuesWithoutDefaultValue()
            }
        }
    }
#endif

#if canImport(UIKit)
import UIKit

extension UIColor: DefaultsSerializable {}

final class DefaultsUIColorSerializableSpec: QuickSpec, DefaultsSerializableSpec {

    typealias Serializable = UIColor

    var customValue: UIColor = .green
    var defaultValue: UIColor = .blue

    override func spec() {
        given("UIColor") {
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
        }
    }
}
#endif
