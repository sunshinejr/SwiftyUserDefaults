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

#if !os(Linux)

public extension DefaultsAdapter {

    func observe<T: DefaultsSerializable>(_ key: DefaultsKey<T>,
                                          options: NSKeyValueObservingOptions = [.new, .old],
                                          handler: @escaping (DefaultsObserver<T>.Update) -> Void) -> DefaultsDisposable {
        return defaults.observe(key, options: options, handler: handler)
    }

    func observe<T: DefaultsSerializable>(_ keyPath: KeyPath<KeyStore, DefaultsKey<T>>,
                                          options: NSKeyValueObservingOptions = [.old, .new],
                                          handler: @escaping (DefaultsObserver<T>.Update) -> Void) -> DefaultsDisposable {
        return defaults.observe(keyStore[keyPath: keyPath],
                                options: options,
                                handler: handler)
    }
}

public extension UserDefaults {

    func observe<T: DefaultsSerializable>(_ key: DefaultsKey<T>, options: NSKeyValueObservingOptions = [.old, .new], handler: @escaping (DefaultsObserver<T>.Update) -> Void) -> DefaultsDisposable {
        return DefaultsObserver(key: key, userDefaults: self, options: options, handler: handler)
    }
}

#endif
