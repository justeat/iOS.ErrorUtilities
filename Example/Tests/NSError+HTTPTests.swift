import XCTest
@testable import ErrorUtilities

let testDomain = "com.justeat.errorUtilities"

class NSError_APITests: XCTestCase {
    
    func test_clientError() {
        let error1 = NSError(domain: testDomain, code: 400, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 499, userInfo: nil)
        let error3 = NSError(domain: testDomain, code: 500, userInfo: nil)
        XCTAssertTrue(error1.isClientError())
        XCTAssertTrue(error2.isClientError())
        XCTAssertFalse(error3.isClientError())
    }
    
    func test_serverError() {
        let error1 = NSError(domain: testDomain, code: 500, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 400, userInfo: nil)
        let error3 = NSError(domain: testDomain, code: 499, userInfo: nil)
        XCTAssertTrue(error1.isServerError())
        XCTAssertFalse(error2.isServerError())
        XCTAssertFalse(error3.isServerError())
    }
    
    func test_timeoutError() {
        let error1 = NSError(domain: testDomain, code: NSURLErrorTimedOut, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 408, userInfo: nil)
        let error3 = NSError(domain: testDomain, code: 504, userInfo: nil)
        let error4 = NSError(domain: testDomain, code: 598, userInfo: nil)
        let error5 = NSError(domain: testDomain, code: 599, userInfo: nil)
        let error6 = NSError(domain: testDomain, code: 400, userInfo: nil)
        XCTAssertTrue(error1.isTimeoutError())
        XCTAssertTrue(error2.isTimeoutError())
        XCTAssertTrue(error3.isTimeoutError())
        XCTAssertTrue(error4.isTimeoutError())
        XCTAssertTrue(error5.isTimeoutError())
        XCTAssertFalse(error6.isTimeoutError())
    }
    
    func test_connectivityError() {
        let error1 = NSError(domain: testDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 500, userInfo: nil)
        XCTAssertTrue(error1.isConnectivityError())
        XCTAssertFalse(error2.isConnectivityError())
    }
    
    func test_tooManyRequestsError() {
        let error1 = NSError(domain: testDomain, code: 429, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 430, userInfo: nil)
        XCTAssertTrue(error1.isTooManyRequestsError())
        XCTAssertFalse(error2.isTooManyRequestsError())
    }
    
    func test_authorizationError() {
        let error1 = NSError(domain: testDomain, code: 401, userInfo: nil)
        let error2 = NSError(domain: testDomain, code: 400, userInfo: nil)
        XCTAssertTrue(error1.isAuthorizationError())
        XCTAssertFalse(error2.isAuthorizationError())
    }
    
    
}
