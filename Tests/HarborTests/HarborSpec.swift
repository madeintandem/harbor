import Quick
import Nimble

@testable import Harbor

class HarborSpec: QuickSpec { override func spec() {
  let subject = Harbor()

  describe("#version") {
    it("is correct") {
      expect(subject.version) == "0.0.1"
    }
  }
}}
