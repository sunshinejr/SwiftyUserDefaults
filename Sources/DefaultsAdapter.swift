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

/// A UserDefaults wrapper. It makes KeyPath dynamicMemberLookup  usable with UserDefaults in Swift 5.1 or greater.
/// If Swift 5.0 or less, It works as ordinary SwiftyUserDefaults.
///
/// - seealso: https://github.com/apple/swift-evolution/blob/master/proposals/0252-keypath-dynamic-member-lookup.md
///
/// Here is a example:
///
/// ```
/// extension DefaultsKeys {
///     var launchCount: DefaultsKey<Int> {
///         return .init("launchCount", defaultValue: 0)
///     }
/// }
///
/// Defaults.launchCount += 1
/// ```
@dynamicMemberLookup
public struct DefaultsAdapter<KeyStore: DefaultsKeyStore> {

    public let defaults: UserDefaults
    public let keyStore: KeyStore

    public init(defaults: UserDefaults, keyStore: KeyStore) {
        self.defaults = defaults
        self.keyStore = keyStore
    }

    @available(*, unavailable)
    public subscript(dynamicMember member: String) -> Never {
        fatalError()
    }

    public func hasKey<T: DefaultsSerializable>(_ key: DefaultsKey<T>) -> Bool {
        return defaults.hasKey(key)
    }

    public func hasKey<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> Bool {
        return defaults.hasKey(keyStore[keyPath: keyPath])
    }

    public func remove<T: DefaultsSerializable>(_ key: DefaultsKey<T>) {
        defaults.remove(key)
    }

    public func remove<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>) {
        defaults.remove(keyStore[keyPath: keyPath])
    }

    public func removeAll() {
        defaults.removeAll()
    }
}
