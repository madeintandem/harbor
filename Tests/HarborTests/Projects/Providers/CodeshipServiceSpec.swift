import Quick
import Nimble

@testable import Harbor

class CodeshipServiceSpec: QuickSpec { override func spec() {
  let subject = CodeshipService(apiKey: "test-key")

  describe("#getProjects") {
    it("fetches all projects") {
      let actual = subject.all()
      expect(actual.map { $0.name }) == ["test"]
    }
  }
}}
