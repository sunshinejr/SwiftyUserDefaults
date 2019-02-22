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

import Foundation

fileprivate let propertyListPrefixes: Set<Character> = [ "{", "[", "(", "<", "\"" ]

// Kudos to stdlib-corelibs-foundation:
// https://github.com/apple/swift-corelibs-foundation/blob/master/Foundation/UserDefaults.swift#L415-L458
internal extension UserDefaults {
    static func _parseArguments(_ arguments: [String]) -> [String: Any] {
        var result: [String: Any] = [:]

        let count = arguments.count

        var index = 0
        while index < count - 1 { // We're looking for pairs, so stop at the second-to-last argument.
            let current = arguments[index]
            let next = arguments[index + 1]
            if current.hasPrefix("-") && !next.hasPrefix("-") {
                // Match what Darwin does, which is to check whether the first argument is one of the characters that make up a NeXTStep-style or XML property list: open brace, open parens, open bracket, open angle bracket, or double quote. If it is, attempt parsing it as a plist; otherwise, just use the argument value as a String.

                let keySubstring = current[current.index(after: current.startIndex)...]
                if !keySubstring.isEmpty {
                    let key = String(keySubstring)
                    let value = next.trimmingCharacters(in: .whitespacesAndNewlines)

                    var parsed = false
                    if let prefix = value.first, propertyListPrefixes.contains(prefix) {
                        if let data = value.data(using: .utf8),
                            let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) {

                            // If we can parse that argument as a plist, use the parsed value.
                            parsed = true
                            result[key] = plist

                        }
                    }

                    if !parsed {
                        result[key] = value
                    }
                }

                index += 1 // Skip both the key and the value on this loop.
            }

            index += 1
        }

        return result
    }
}

