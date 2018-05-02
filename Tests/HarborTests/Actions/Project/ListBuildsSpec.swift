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
    it("throws an error if there is no user") {
      guard case .some(.hasNoUser) = subject.call().error else {
        fail("expected to be missing user")
        return
      }
    }
  }
}}
