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

    private let keyStore: KeyStore
    private let defaults: UserDefaults

    public init(defaults: UserDefaults, keyStore: KeyStore) {
        self.defaults = defaults
        self.keyStore = keyStore
    }

    @available(*, unavailable)
    public subscript(dynamicMember member: String) -> Never {
        fatalError()
    }
}

extension DefaultsAdapter: DefaultsType {

    public subscript<T: DefaultsSerializable>(key: DefaultsKey<T?>) -> T.T? {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(key: DefaultsKey<T>) -> T.T where T == T.T {
        get {
            return defaults[key]
        }
        set {
            defaults[key] = newValue
        }
    }

    public func hasKey<T: DefaultsSerializable>(_ key: DefaultsKey<T>) -> Bool {
        return defaults.hasKey(key)
    }

    public func remove<T: DefaultsSerializable>(_ key: DefaultsKey<T>) {
        defaults.remove(key)
    }

    public func removeAll() {
        defaults.removeAll()
    }

    #if !os(Linux)
    public func observe<T: DefaultsSerializable>(_ key: DefaultsKey<T>,
                                                 options: NSKeyValueObservingOptions = [.new, .old],
                                                 handler: @escaping (DefaultsObserver<T>.Update) -> Void) -> DefaultsDisposable {
        return defaults.observe(key, options: options, handler: handler)
    }
    #endif
}

extension DefaultsAdapter {

    public func hasKey<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> Bool {
        return defaults.hasKey(keyStore[keyPath: keyPath])
    }

    public func remove<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>) {
        defaults.remove(keyStore[keyPath: keyPath])
    }

    #if !os(Linux)
    public func observe<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>,
                                                 options: NSKeyValueObservingOptions = [.old, .new],
                                                 handler: @escaping (DefaultsObserver<T>.Update) -> Void) -> DefaultsDisposable {
        return defaults.observe(keyStore[keyPath: keyPath],
                                options: options,
                                handler: handler)
    }
    #endif
}

#if swift(>=5.1)
extension DefaultsAdapter {

    public subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T?>>) -> T.T? {
        get {
            return defaults[keyStore[keyPath: keyPath]]
        }
        set {
            defaults[keyStore[keyPath: keyPath]] = newValue
        }
    }

    public subscript<T: DefaultsSerializable>(dynamicMember keyPath: KeyPath<KeyStore, DefaultsKey<T>>) -> T.T where T.T == T {
        get {
            return defaults[keyStore[keyPath: keyPath]]
        }
        set {
            defaults[keyStore[keyPath: keyPath]] = newValue
        }
    }
}
#endif
