import Quick
import Nimble
import Foundation

@testable import Harbor

class ListProjectsSpec: QuickSpec { override func spec() {
  var subject: User.ListProjects!

  beforeEach {
    subject = User.ListProjects()
  }

  describe("#call") {
    it("lists all the user's projects") {
      let response = subject.call()
      expect(response.value).to(haveCount(0))
    }
  }
}}
