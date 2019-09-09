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

#if canImport(Combine)

import Combine
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension DefaultsAdapter {

    func publisher<T: DefaultsSerializable>(for keyPath: KeyPath<KeyStore, DefaultsKey<T>>, options: NSKeyValueObservingOptions = [.old, .new]) -> AnyPublisher<T, Never> where T: OptionalType, T.T == T {
        return publisher(for: keyStore[keyPath: keyPath], options: options)
    }

    func publisher<T: DefaultsSerializable>(for key: DefaultsKey<T>, options: NSKeyValueObservingOptions = [.old, .new]) -> AnyPublisher<T, Never> where T: OptionalType, T.T == T {
        let defaults = self.defaults

        return SwiftyUserDefaultsPublisher { subscriber -> Cancellable? in
            let disposable = defaults.observe(key, options: options) { update in
                if let newValue = update.newValue {
                    _ = subscriber.receive(newValue)
                } else {
                    _ = subscriber.receive(.empty)
                }
            }

            return AnyCancellable {
                subscriber.receive(completion: .finished)
                disposable.dispose()
            }
        }
        .eraseToAnyPublisher()
    }

    func publisher<T: DefaultsSerializable>(for keyPath: KeyPath<KeyStore, DefaultsKey<T>>, options: NSKeyValueObservingOptions = [.old, .new]) -> AnyPublisher<T, Never> where T.T == T {
        return publisher(for: keyStore[keyPath: keyPath], options: options)
    }

    func publisher<T: DefaultsSerializable>(for key: DefaultsKey<T>, options: NSKeyValueObservingOptions = [.old, .new]) -> AnyPublisher<T, Never> where T.T == T {
        let defaults = self.defaults

        return SwiftyUserDefaultsPublisher { subscriber -> Cancellable? in
            let disposable = defaults.observe(key, options: options) { update in
                if let newValue = update.newValue {
                    _ = subscriber.receive(newValue)
                }
            }

            return AnyCancellable {
                subscriber.receive(completion: .finished)
                disposable.dispose()
            }
        }
        .eraseToAnyPublisher()
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
internal class SwiftyUserDefaultsPublisher<Output>: Publisher {

    internal typealias Failure = Never

    private class Subscription: Combine.Subscription {

        private let cancellable: Cancellable?

        init(subscriber: AnySubscriber<Output, Failure>, callback: @escaping (AnySubscriber<Output, Failure>) -> Cancellable?) {
            self.cancellable = callback(subscriber)
        }

        func request(_ demand: Subscribers.Demand) {
            // We don't care for the demand right now
        }

        func cancel() {
            cancellable?.cancel()
        }
    }

    private let callback: (AnySubscriber<Output, Failure>) -> Cancellable?

    internal init(callback: @escaping (AnySubscriber<Output, Failure>) -> Cancellable?) {
        self.callback = callback
    }

    internal func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: AnySubscriber(subscriber), callback: callback)
        subscriber.receive(subscription: subscription)
    }
}

#endif
