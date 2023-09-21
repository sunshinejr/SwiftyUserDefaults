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

#if swift(>=5.1)
public struct SwiftyUserDefaultOptions: OptionSet {

    public static let cached = SwiftyUserDefaultOptions(rawValue: 1 << 0)
    public static let observed = SwiftyUserDefaultOptions(rawValue: 1 << 2)

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}


@propertyWrapper
public struct SwiftyDefaults<T: DefaultsSerializable> where T.T == T {
    public let key: DefaultsKey<T>
    private var _value: T.T
    public var wrappedValue: T.T {
        get { _value }
        set {
            _value = newValue
            Defaults[key: key] = newValue
        }
    }
    public init(keyPath: KeyPath<DefaultsKeys, DefaultsKey<T>>) {
        self.key = Defaults.keyStore[keyPath: keyPath]
        self._value = Defaults[key: self.key]
    }
    public init(key: String, defaultValue value: T) {
        self.key = DefaultsKey(key, defaultValue: value)
        self._value = Defaults[key: self.key]
    }
}
extension SwiftyDefaults where T: OptionalType, T.Wrapped: DefaultsSerializable {
    public init(key: String) {
        self.init(key: key, defaultValue: T.__swifty_empty)
    }
}

@propertyWrapper
public final class SwiftyUserDefault<T: DefaultsSerializable> where T.T == T {

    public let key: DefaultsKey<T>
    public let options: SwiftyUserDefaultOptions

    public var wrappedValue: T {
        get {
            if options.contains(.cached) {
                if let v = _value { return v }
                let v = Defaults[key: key]
                _value = v
                return v
            } else {
                return Defaults[key: key]
            }
        }
        set {
            _value = newValue
            Defaults[key: key] = newValue
        }
    }

    private var _value: T.T?
    private var observation: DefaultsDisposable?

    public init<KeyStore>(keyPath: KeyPath<KeyStore, DefaultsKey<T>>, adapter: DefaultsAdapter<KeyStore>, options: SwiftyUserDefaultOptions = []) {
        self.key = adapter.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            observation = adapter.observe(key) { [weak self] update in
                self?._value = update.newValue
            }
        }
    }

    public init(keyPath: KeyPath<DefaultsKeys, DefaultsKey<T>>, options: SwiftyUserDefaultOptions = []) {
        self.key = Defaults.keyStore[keyPath: keyPath]
        self.options = options

        if options.contains(.observed) {
            observation = Defaults.observe(key) { [weak self] update in
                self?._value = update.newValue
            }
        }
    }

    public init(key: String, defaultValue value: T, options: SwiftyUserDefaultOptions = []) {
        self.key = DefaultsKey(key, defaultValue: value)
        self.options = options

        if options.contains(.observed) {
            observation = Defaults.observe(self.key) { [weak self] update in
                self?._value = update.newValue
            }
        }
    }
    deinit {
        observation?.dispose()
    }
}
extension SwiftyUserDefault where T: OptionalType, T.Wrapped: DefaultsSerializable {
    public convenience init(key: String, options: SwiftyUserDefaultOptions = []) {
        self.init(key: key, defaultValue: T.__swifty_empty, options: options)
    }
}


#endif
