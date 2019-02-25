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

import Quick

final class DefaultsBoolSpec: QuickSpec, DefaultsSerializableSpec {

    typealias Serializable = Bool

    var customValue: Bool = true
    var defaultValue: Bool = false

    override func spec() {
        given("Bool") {
            self.testValues()
            self.testOptionalValues()
            self.testOptionalValuesWithoutDefaultValue()
            self.testObserving()
            self.testPlistRegisteringValues(valueStrings: ["YES": true,
                                                           "yes": true,
                                                           "TRUE": true,
                                                           "true": true,
                                                           "Y": true,
                                                           "y": true,
                                                           "T": true,
                                                           "t": true,
                                                           "1": true,
                                                           "NO": false,
                                                           "no": false,
                                                           "FALSE": false,
                                                           "false": false,
                                                           "N": false,
                                                           "n": false,
                                                           "f": false,
                                                           "F": false,
                                                           "0": false,
                                                           "blabla": nil,
                                                           "test": nil])
        }
    }
}
