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

public protocol DefaultsDisposable {
    func dispose()
}

#if !os(Linux)

public final class DefaultsObserver<T: DefaultsSerializable>: NSObject, DefaultsDisposable where T == T.T {

    public struct Update {
        public let kind: NSKeyValueChange
        public let indexes: IndexSet?
        public let isPrior: Bool
        public let newValue: T.T?
        public let oldValue: T.T?

        init(dict: [NSKeyValueChangeKey: Any], key: DefaultsKey<T>) {
            // swiftlint:disable:next force_cast
            kind = NSKeyValueChange(rawValue: dict[.kindKey] as! UInt)!
            indexes = dict[.indexesKey] as? IndexSet
            isPrior = dict[.notificationIsPriorKey] as? Bool ?? false
            oldValue = Update.deserialize(dict[.oldKey], for: key) ?? key.defaultValue
            newValue = Update.deserialize(dict[.newKey], for: key) ?? key.defaultValue
        }

        private static func deserialize<T: DefaultsSerializable>(_ value: Any?, for key: DefaultsKey<T>) -> T.T? where T.T == T {
            guard let value = value else { return nil }

            let deserialized =  T._defaults.deserialize(value)

            let ret: T.T?
            if key.isOptional, let _deserialized = deserialized, let __deserialized = _deserialized as? OptionalTypeCheck, !__deserialized.isNil {
                ret = __deserialized as? T.T
            } else if !key.isOptional {
                ret = deserialized ?? value as? T.T
            } else {
                ret = value as? T.T
            }

            return ret
        }
    }

    private let key: DefaultsKey<T>
    private let userDefaults: UserDefaults
    private let handler: ((Update) -> Void)
    private var didRemoveObserver = false

    init(key: DefaultsKey<T>, userDefaults: UserDefaults, options: NSKeyValueObservingOptions, handler: @escaping ((Update) -> Void)) {
        self.key = key
        self.userDefaults = userDefaults
        self.handler = handler
        super.init()

        userDefaults.addObserver(self, forKeyPath: key._key, options: options, context: nil)
    }

    deinit {
        dispose()
    }

    // swiftlint:disable:next block_based_kvo
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key._key else {
            return
        }

        let update = Update(dict: change, key: key)
        handler(update)
    }

    public func dispose() {
        // We use this local property because when you use `removeObserver` when you are
        // not actually observing anymore, you'll receive a runtime error.
        if didRemoveObserver { return }

        didRemoveObserver = true
        userDefaults.removeObserver(self, forKeyPath: key._key, context: nil)
    }
}

#endif
