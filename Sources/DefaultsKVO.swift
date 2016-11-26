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

public struct DefaultsKVO {

    public typealias Token = Int64
    public typealias EventHandler = (UserDefaults.Proxy) -> Void

    private static let lock: NSRecursiveLock = {
        let lock = NSRecursiveLock()
        lock.name = "radex.SwiftyUserDefaults"
        return lock
    }()
    private static var instance = DefaultsKVO()

    private var _nextToken: Token = 0

    public static func nextToken() -> Token {

        lock.lock()
        let token = instance._nextToken
        instance._nextToken += 1
        lock.unlock()

        return token
    }
}

private var SwiftyUserDefaultsKVOContext: UnsafeMutableRawPointer? = nil
private var kvoKeyAndHandlers = [String: [BlockDisposable]]()

public final class BlockDisposable {

    let key: String
    private let token: DefaultsKVO.Token
    var handler: DefaultsKVO.EventHandler?

    init(key: String, handler: @escaping DefaultsKVO.EventHandler) {

        self.token = DefaultsKVO.nextToken()

        self.key = key
        self.handler = handler
    }

    public func dispose() {

        guard var handlers = kvoKeyAndHandlers[key]
            else { return }

        if let idx = handlers.index(where: { e in
            return e.token == self.token
        }) {
            handlers.remove(at: idx)
        }
        Defaults.removeObserver(Defaults, forKeyPath: key)
        handler = nil
    }
}

extension UserDefaults {

    public func observe(
        key: String,
        options: NSKeyValueObservingOptions = [.new],
        handler: @escaping DefaultsKVO.EventHandler) -> BlockDisposable {

        let key = DefaultsKey<String>(key)
        return observe(key: key, handler: handler)
    }

    public func observe<T>(
        key: DefaultsKey<T>,
        options: NSKeyValueObservingOptions = [.new],
        handler: @escaping DefaultsKVO.EventHandler) -> BlockDisposable {

        let block = BlockDisposable(key: key._key, handler: handler)
        if let _ = kvoKeyAndHandlers[key._key] {
            kvoKeyAndHandlers[key._key]!.append(block)
        } else {
            kvoKeyAndHandlers[key._key] = [block]
        }
        self.addObserver(self, forKeyPath: key._key,
                         options: options, context: SwiftyUserDefaultsKVOContext)
        return block
    }

    open override func observeValue(
        forKeyPath maybeKeyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {

        guard let keyPath = maybeKeyPath,
            let handlers = kvoKeyAndHandlers[keyPath],
            context == SwiftyUserDefaultsKVOContext
            else {
                super.observeValue(forKeyPath: maybeKeyPath, of: object, change: change, context: context);
                return
        }
        
        let value: Proxy = Defaults[keyPath]
        handlers.forEach { $0.handler?(value) }
    }
}
