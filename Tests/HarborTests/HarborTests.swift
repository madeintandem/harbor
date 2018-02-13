import Quick
import Nimble

@testable import Harbor

class HarborSpec: QuickSpec { override func spec() {
  describe("#text") {
    it("is 'hello, world'") {
      expect(Harbor().text) == "hello, world"
    }
  }
}}
