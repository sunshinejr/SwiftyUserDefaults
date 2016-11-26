//
// DefaultsKVO
// Created by Christian Tietze on 2016-11-26.
// Adapted from github.com/toshi0383
//
// Copyright (c) 2015-2016 Radosław Pietruszewski
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

extension Array {

    func appending(_ newElement: Element) -> [Element] {
        var result = self
        result.append(newElement)
        return result
    }
}

public struct DefaultsKVO {

    public typealias Token = Int64

    private static let lock: NSRecursiveLock = {
        let lock = NSRecursiveLock()
        lock.name = "radex.SwiftyUserDefaults"
        return lock
    }()
    private static var instance = DefaultsKVO()

    /// List of handlers for each key.
    private var _handlers = [String : [BlockDisposable]]()
    private var _nextToken: Token = 0

    public static func nextToken() -> Token {

        lock.lock()
        let token = instance._nextToken
        instance._nextToken += 1
        lock.unlock()

        return token
    }

    public static func handlers(key: String) -> [BlockDisposable] {

        return instance._handlers[key] ?? []
    }

    public static func removeHandler(token: Token, forKey key: String) {

        guard let handlers = instance._handlers[key]
            else { return }

        instance._handlers[key] = handlers
            .filter { $0.token != token }
    }

    public static func add(handler: BlockDisposable, forKey key: String) {

        instance._handlers[key] = handlers(key: key).appending(handler)
    }

    public static func notifyHandlers(forKey key: String, newValue value: UserDefaults.Proxy) {

        handlers(key: key).forEach { $0.handler?(value) }
    }
}

private var SwiftyUserDefaultsKVOContext: UnsafeMutableRawPointer? = nil

public final class BlockDisposable {

    let key: String
    let token: DefaultsKVO.Token
    var handler: UserDefaults.KVOEventHandler?

    init(key: String, handler: @escaping UserDefaults.KVOEventHandler) {

        self.token = DefaultsKVO.nextToken()

        self.key = key
        self.handler = handler
    }

    public func dispose() {

        DefaultsKVO.removeHandler(token: token, forKey: key)
        Defaults.removeObserver(Defaults, forKeyPath: key)
        handler = nil
    }
}

extension UserDefaults {

    public typealias KVOEventHandler = (UserDefaults.Proxy) -> Void

    public func observe(
        key: String,
        options: NSKeyValueObservingOptions = [.new],
        handler: @escaping KVOEventHandler) -> BlockDisposable {

        let key = DefaultsKey<String>(key)
        return observe(key: key, handler: handler)
    }

    public func observe<T>(
        key: DefaultsKey<T>,
        options: NSKeyValueObservingOptions = [.new],
        handler: @escaping KVOEventHandler) -> BlockDisposable {

        let disposable = BlockDisposable(key: key._key, handler: handler)
        DefaultsKVO.add(handler: disposable, forKey: key._key)
        self.addObserver(self,
                         forKeyPath: key._key,
                         options: options,
                         context: SwiftyUserDefaultsKVOContext)
        return disposable
    }

    open override func observeValue(
        forKeyPath maybeKeyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {

        guard context == SwiftyUserDefaultsKVOContext,
            let keyPath = maybeKeyPath
            else {
                super.observeValue(forKeyPath: maybeKeyPath, of: object, change: change, context: context);
                return
        }

        let value: Proxy = Defaults[keyPath]
        DefaultsKVO.notifyHandlers(forKey: keyPath, newValue: value)
    }
}
