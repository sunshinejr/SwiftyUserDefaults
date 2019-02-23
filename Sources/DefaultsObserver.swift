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

public final class DefaultsObserver<T: DefaultsSerializable>: NSObject, DefaultsDisposable {

    public struct Update {
        public let kind: NSKeyValueChange
        public let indexes: IndexSet?
        public let isPrior: Bool
        public let newValue: T.T?
        public let oldValue: T.T?

        init(dict: [NSKeyValueChangeKey: Any], defaultValue: T.T?) {
            kind = NSKeyValueChange(rawValue: dict[.kindKey] as! UInt)!
            indexes = dict[.indexesKey] as? IndexSet
            isPrior = dict[.notificationIsPriorKey] as? Bool ?? false
            oldValue = dict[.oldKey] as? T.T ?? defaultValue
            newValue = dict[.newKey] as? T.T
        }
    }

    private let key: DefaultsKey<T>
    private let userDefaults: UserDefaults
    private let handler: ((Update) -> Void)

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

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change, object != nil, keyPath == key._key else {
            return
        }

        let update = Update(dict: change, defaultValue: key.defaultValue)
        handler(update)
    }

    public func dispose() {
        userDefaults.removeObserver(self, forKeyPath: key._key, context: nil)
    }
}

