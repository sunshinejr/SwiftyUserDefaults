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
public final class SwiftyUserDefault<T: DefaultsSerializable> where T.T == T {

    public let key: DefaultsKey<T>
    public let options: SwiftyUserDefaultOptions

    public var wrappedValue: T {
        get {
            if options.contains(.cached) {
                return _value ?? Defaults[key: key]
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

    deinit {
        observation?.dispose()
    }
}
#endif
