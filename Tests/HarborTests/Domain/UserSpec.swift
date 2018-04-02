import Quick
import Nimble
import Foundation

@testable import Harbor

class UserSpec: QuickSpec { override func spec() {
  var subject: User!

  beforeEach {
    subject = User(
      email: "test@email.com"
    )
  }

  describe("#signIn") {
    it("signs in the user") {
      let session = Session(
        token: "test-token",
        expiresAt: Date()
      )

      subject.signIn(with: session)
      expect(subject.session) == session
    }
  }
}}
