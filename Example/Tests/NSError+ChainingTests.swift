import XCTest
@testable import ErrorUtilities

class ErrorsTests: XCTestCase {
    
    static let errorsChain: [NSError] = {
        var tempErrors: [NSError] = []
        for index in 0...6 {
            let errorNumber = "\(index)"
            let description = "Description of \(index)"
            tempErrors.append(NSError(domain: errorNumber, code: index, userInfo: [NSLocalizedDescriptionKey: description] ))
        }
        return tempErrors
    }()
    
    static let errorWithUnderlyingErrors: NSError = {
        var error3 = NSError(domain: "3", code: 3, userInfo: [NSLocalizedDescriptionKey: "Description of 3"])
        var error2 = NSError(domain: "2", code: 2, userInfo: [NSLocalizedDescriptionKey: "Description of 2", NSUnderlyingErrorKey: error3])
        var error1 = NSError(domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "Description of 1", NSUnderlyingErrorKey: error2])
        var error0 = NSError(domain: "0", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description of 0", NSUnderlyingErrorKey: error1])
        return error0
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - static func error(underlyingErrors: [NSError]) -> NSError?
    
    func test_errorUnderlyingErrors_positive() {
        let error = NSError.error(underlyingErrors: ErrorsTests.errorsChain)
        
        var tempError = error
        for index in 0...6 {
            XCTAssert(tempError?.code == index)
            XCTAssert(tempError?.domain == "\(index)")
            tempError = tempError?.userInfo[NSUnderlyingErrorKey] as? NSError
        }
    }
    
    func test_errorUnderlyingErrors_emptyErrors() {
        let error = NSError.error(underlyingErrors: [])
        XCTAssertNil(error)
    }
    
    //MARK: - static func error(underlyingError: NSError?, domain: String, code: Int, userInfo: [AnyHashable : Any]? = nil) -> NSError
    
    func test_errorUnderlyingErrorDomainCodeUserInfo_positive() {
        let underError = NSError(domain: "0", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description of 0"])
        let error = NSError.error(underlyingError: underError, domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "Description of 1"])
        
        XCTAssert(error.code == 1)
        XCTAssert(error.domain == "1")
        XCTAssert(error.userInfo.count == 2)
        let underErrorFound = error.userInfo[NSUnderlyingErrorKey] as! NSError
        XCTAssert(underErrorFound.isEqual(underError))
        XCTAssertNil(underErrorFound.userInfo[NSUnderlyingErrorKey])
    }
    
    func test_errorUnderlyingErrorDomainCodeUserInfo_nilError() {
        let error = NSError.error(underlyingError: nil, domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "Description of 1"])
        
        XCTAssert(error.code == 1)
        XCTAssert(error.domain == "1")
        XCTAssert(error.userInfo.count == 1)
        XCTAssertNil(error.userInfo[NSUnderlyingErrorKey])

    }
    
    //MARK: - func errorByAdding(underlyingError: NSError) -> NSError
    
    func test_errorByAddingUnderlyingError_positive() {
        let underError = NSError(domain: "0", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description of 0"])
        let error = NSError(domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "Description of 1"])
        let resultError = error.errorByAdding(underlyingError: underError)
        
        XCTAssert(resultError.code == 1)
        XCTAssert(resultError.domain == "1")
        XCTAssert(resultError.userInfo.count == 2)
        XCTAssertNotNil(resultError.userInfo[NSUnderlyingErrorKey])
    }
    
    //MARK: - func errorByConcatenating(errors:NSError...) -> NSError?
    
    func test_errorByConcatenatingErrors_positive() {
        let error4 = NSError(domain: "4", code: 4, userInfo: [NSLocalizedDescriptionKey: "Description of 4"])
        
        let error3 = NSError(domain: "3", code: 3, userInfo: [NSLocalizedDescriptionKey: "Description of 3"])
        let error2 = NSError(domain: "2", code: 2, userInfo: [NSLocalizedDescriptionKey: "Description of 2", NSUnderlyingErrorKey: error3])
        
        let error1 = NSError(domain: "1", code: 1, userInfo: [NSLocalizedDescriptionKey: "Description of 1"])
        let error0 = NSError(domain: "0", code: 0, userInfo: [NSLocalizedDescriptionKey: "Description of 0", NSUnderlyingErrorKey: error1])
        
        let error = NSError.errorByConcatenating([error0, error2, error4])
        
        let errorChain = error?.errorChain()
        XCTAssert(errorChain?.count == 5)
        XCTAssert(errorChain?[0].code == 0)
        XCTAssert(errorChain?[0].domain == "0")
        XCTAssert(errorChain?[1].code == 1)
        XCTAssert(errorChain?[1].domain == "1")
        XCTAssert(errorChain?[2].code == 2)
        XCTAssert(errorChain?[2].domain == "2")
        XCTAssert(errorChain?[3].code == 3)
        XCTAssert(errorChain?[3].domain == "3")
        XCTAssert(errorChain?[4].code == 4)
        XCTAssert(errorChain?[4].domain == "4")
    }
    
    func test_errorByConcatenatingErrors_empty() {
        let error = NSError.errorByConcatenating([])
        XCTAssertNil(error)
    }
    
    //MARK: - func errorChain() -> [NSError]
    
    func test_errorChain_positive() {
        let errorChain = ErrorsTests.errorWithUnderlyingErrors.errorChain()
        
        XCTAssert(errorChain.count == 4)
        XCTAssert(errorChain[0].code == 0)
        XCTAssert(errorChain[0].domain == "0")
        XCTAssertNotNil(errorChain[0].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[1].code == 1)
        XCTAssert(errorChain[1].domain == "1")
        XCTAssertNotNil(errorChain[1].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[2].code == 2)
        XCTAssert(errorChain[2].domain == "2")
        XCTAssertNotNil(errorChain[2].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[3].code == 3)
        XCTAssert(errorChain[3].domain == "3")
        XCTAssertNil(errorChain[3].userInfo[NSUnderlyingErrorKey])
    }
    
    func test_errorChain_NoUnderlying() {
        let error = NSError(domain: "0", code: 0, userInfo: nil)
        let errorChain = error.errorChain()
        
        XCTAssertEqual(errorChain.count, 1)
    }
    
    //MARK: - func disassociatedErrorChain() -> [NSError]
    
    func test_disassociatedErrorChain_positive() {
        let errorChain = ErrorsTests.errorWithUnderlyingErrors.disassociatedErrorChain()
        
        XCTAssert(errorChain.count == 4)
        XCTAssert(errorChain[0].code == 0)
        XCTAssert(errorChain[0].domain == "0")
        XCTAssertNil(errorChain[0].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[1].code == 1)
        XCTAssert(errorChain[1].domain == "1")
        XCTAssertNil(errorChain[1].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[2].code == 2)
        XCTAssert(errorChain[2].domain == "2")
        XCTAssertNil(errorChain[2].userInfo[NSUnderlyingErrorKey])
        XCTAssert(errorChain[3].code == 3)
        XCTAssert(errorChain[3].domain == "3")
        XCTAssertNil(errorChain[3].userInfo[NSUnderlyingErrorKey])
    }
    
    func test_disassociatedErrorChain_NoUnderlying() {
        let error = NSError(domain: "0", code: 0, userInfo: nil)
        let errorChain = error.disassociatedErrorChain()
        
        XCTAssertEqual(errorChain.count, 1)
    }
    
    //MARK: - func subsequentErrorChain() -> [NSError]
    
    func test_subsequentErrorChain_positive() {
        let errorChain = ErrorsTests.errorWithUnderlyingErrors.subsequentErrorChain()
        
        XCTAssert(errorChain.count == 3)
        XCTAssert(errorChain[0].code == 1)
        XCTAssert(errorChain[0].domain == "1")
        XCTAssert(errorChain[1].code == 2)
        XCTAssert(errorChain[1].domain == "2")
        XCTAssert(errorChain[2].code == 3)
        XCTAssert(errorChain[2].domain == "3")
    }
    
    func test_subsequentErrorChain_NoUnderlying() {
        let error = NSError(domain: "0", code: 0, userInfo: nil)
        let errorChain = error.subsequentErrorChain()
        
        XCTAssertEqual(errorChain.count, 0)
    }
    
    //MARK: - func isPresentUnderlyingError(code: Int) -> Bool
    
    func test_isPresentUnderlyingErrorCode() {
        let errorWithUnderlyingErrors = ErrorsTests.errorWithUnderlyingErrors
        
        XCTAssertTrue(errorWithUnderlyingErrors.isPresentUnderlyingError(code: 0))
        XCTAssertTrue(errorWithUnderlyingErrors.isPresentUnderlyingError(code: 1))
        XCTAssertTrue(errorWithUnderlyingErrors.isPresentUnderlyingError(code: 2))
        XCTAssertTrue(errorWithUnderlyingErrors.isPresentUnderlyingError(code: 3))
        XCTAssertFalse(errorWithUnderlyingErrors.isPresentUnderlyingError(code: 4))
    }
    
    //MARK: - func isUnderlyingError(within range: NSRange, domain: String? = nil) -> Bool
    
    func test_isUnderlyingErrorWithinRangeDomain() {
        let errorWithUnderlyingErrors = ErrorsTests.errorWithUnderlyingErrors
        
        //error 2
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(2, 1), domain: nil))
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(2, 1), domain: "2"))
        
        //error 3
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(3, 1), domain: nil))
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(3, 1), domain: "3"))
        
        //wrong domain for the given range -> not found
        XCTAssertFalse(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(3, 1), domain: "2"))
        
        //Wrong range
        XCTAssertFalse(errorWithUnderlyingErrors.isUnderlyingError(within: NSMakeRange(100, 100), domain: nil))
    }
    
    //MARK: - func isUnderlyingError(partOf codesArray: [Int], domain: String? = nil) -> Bool
    
    func test_isUnderlyingErrorPartOfCodesArrayDomain() {
        let errorWithUnderlyingErrors = ErrorsTests.errorWithUnderlyingErrors
        
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [0,1,2,3], domain: nil))
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [0,1,2,3], domain: "2"))
        
        //error 2
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [2], domain: nil))
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [2], domain: "2"))
        
        //error 3
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [3], domain: nil))
        XCTAssertTrue(errorWithUnderlyingErrors.isUnderlyingError(partOf: [3], domain: "3"))
        
        //wrong domain for the given codes -> not found
        XCTAssertFalse(errorWithUnderlyingErrors.isUnderlyingError(partOf: [2], domain: "3"))
        
        //Not found
        XCTAssertFalse(errorWithUnderlyingErrors.isUnderlyingError(partOf: [100,101,102], domain: nil))
    }
    
}
