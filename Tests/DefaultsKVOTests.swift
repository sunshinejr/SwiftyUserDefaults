import XCTest
@testable import SwiftyUserDefaults

class DefaultsKVOTests: XCTestCase {

    override func setUp() {
        super.setUp()
        clearDefaults()
    }

    func testKVO_ReceivesChanges() {
        Defaults["count"] = 0
        let ex = expectation(description: "`count` should be increased.")
        let disposable = Defaults.observe(key: "count") { proxy in
            if let int = proxy.int, int == 1 {
                ex.fulfill()
            } else {
                XCTFail()
            }
        }
        Defaults["count"] = 1
        waitForExpectations(timeout: 0.1, handler: nil)
        disposable.dispose()
        Defaults.remove("count")
    }

    func testKVO_DisposingRemovesObserver() {
        Defaults["count"] = 0
        let disposable = Defaults.observe(key: "count") { proxy in
            XCTFail()
        }
        XCTAssert(UserDefaults.KVO.hasHandlers(forKey: "count"))
        disposable.dispose()
        Defaults["count"] = 1
        XCTAssert(disposable.handler == nil)
        XCTAssertFalse(UserDefaults.KVO.hasHandlers(forKey: "count"))
    }

    func testKVO_DisposingRemovesHandler() {
        Defaults["count"] = 0
        let disposable = Defaults.observe(key: "count") { proxy in
            XCTFail()
        }
        let ex = expectation(description: "`count` should be increased.")
        let disposable2 = Defaults.observe(key: "count") { proxy in
            if let int = proxy.int, int == 1 {
                ex.fulfill()
            } else {
                XCTFail()
            }
        }
        disposable.dispose()
        Defaults["count"] = 1
        XCTAssert(disposable.handler == nil)
        XCTAssert(disposable2.handler != nil)
        waitForExpectations(timeout: 0.1, handler: nil)
        disposable2.dispose()

        XCTAssert(disposable2.handler == nil)
    }

    func testKVO_WithPlainFoundation() {
        UserDefaults.standard.set(0, forKey: "count")
        let ex = expectation(description: "`count` should be increased.")
        let disposable = Defaults.observe(key: "count") { proxy in

            if let int = proxy.int, int == 1 {
                ex.fulfill()
            } else {
                XCTFail()
            }
        }
        UserDefaults.standard.set(1, forKey: "count")
        waitForExpectations(timeout: 0.1, handler: nil)
        disposable.dispose()
    }
}
