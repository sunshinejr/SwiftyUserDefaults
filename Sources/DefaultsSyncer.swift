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
#if !os(Linux)

import Foundation

internal class DefaultsSyncer {

    let defaults: UserDefaults

    var syncedKeys = Set<String>() {
        didSet { iCloudDefaultsDidUpdate() }
    }

    init(defaults: UserDefaults) {
        self.defaults = defaults
        iCloudDefaultsDidUpdate()
        NotificationCenter.default.addSafeObserver(self,
                                                   selector: #selector(iCloudDefaultsDidUpdate),
                                                   name: NSUbiquitousKeyValueStore.didChangeExternallyNotification)
        NotificationCenter.default.addSafeObserver(self,
                                                   selector: #selector(localDefaultsDidUpdate),
                                                   name: UserDefaults.didChangeNotification)
    }

    @objc
    private func iCloudDefaultsDidUpdate() {
        guard !syncedKeys.isEmpty else { return }

        // HouseKeeping
        NotificationCenter.default.removeObserver(self,
                                                  name: UserDefaults.didChangeNotification,
                                                  object: nil)
        defer {
            NotificationCenter.default.addSafeObserver(self,
                                                       selector: #selector(localDefaultsDidUpdate),
                                                       name: UserDefaults.didChangeNotification)
        }

        // Implementation
        let allICloudKeys = Set(NSUbiquitousKeyValueStore.default.dictionaryRepresentation.keys)
        let updatedSyncedKeys = allICloudKeys.filter { syncedKeys.contains($0) }
        updatedSyncedKeys.forEach { key in
            let iCloudValue = NSUbiquitousKeyValueStore.default.object(forKey: key)
            defaults.set(iCloudValue, forKey: key)
        }
    }

    @objc
    private func localDefaultsDidUpdate() {
        guard !syncedKeys.isEmpty else { return }
        syncedKeys.forEach { key in
            let localValue = defaults.object(forKey: key)
            NSUbiquitousKeyValueStore.default.set(localValue, forKey: key)
        }
        // request upload to ICloud
        NSUbiquitousKeyValueStore.default.synchronize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UserDefaults.didChangeNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                                  object: nil)
    }
}

private extension NotificationCenter {
    func addSafeObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name, object anObject: Any? = nil) {
        removeObserver(observer, name: aName, object: anObject)
        addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
}

#endif
