import XCTest
@testable import MessengerSdk

final class MessengerSdkTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MessengerSdk().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
