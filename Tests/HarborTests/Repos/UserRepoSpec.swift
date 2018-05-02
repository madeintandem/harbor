import Quick
import Nimble
import Foundation

@testable import Harbor

class UserRepoSpec: QuickSpec { override func spec() {
  var subject: UserRepo!

  beforeEach {
    subject = UserRepo()
  }

  describe("#current") {
    it("is the signed-in user") {
      expect(subject.current).to(beNil())

      let user = User("test@email.com")
      Current.user = user
      expect(subject.current) === user
    }
  }
}}
