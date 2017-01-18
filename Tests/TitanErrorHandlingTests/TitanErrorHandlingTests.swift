import XCTest
import TitanErrorHandling
import TitanCore

class TitanErrorHandlingTests: XCTestCase {
    func testErrorsAreCaught() {
      let t = Titan()
      let errorHandler: (Error) -> ResponseType = { (err: Error) in
        let desc = String(describing: err)
        return Response(500, desc)
      }
      t.addFunction(errorHandler: errorHandler) { (req, res) throws -> (RequestType, ResponseType) in
        throw "Oh no"
      }
      XCTAssertEqual(t.app(request: Request("", "")).body, "Oh no")
    }


    static var allTests : [(String, (TitanErrorHandlingTests) -> () throws -> Void)] {
        return [
            ("testErrorsAreCaught", testErrorsAreCaught),
        ]
    }
}

extension String: Error {

}
