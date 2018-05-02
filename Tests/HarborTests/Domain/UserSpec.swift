import Quick
import Nimble
import Foundation

@testable import Harbor

class UserSpec: QuickSpec { override func spec() {
  var subject: User!

  beforeEach {
    subject = User("test@email.com")
  }

  describe("#signIn") {
    it("signs in the user") {
      let session = Session(
        accessToken: Test.token(),
        expiresAt: Date()
      )

      let organizations = [
        Organization(Test.id())
      ]

      subject.signIn(session, organizations)
      expect(subject.session) == session
      expect(subject.organizations) == organizations
    }
  }
}}
