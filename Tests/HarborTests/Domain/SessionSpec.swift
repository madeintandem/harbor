import Quick
import Nimble
import Foundation

@testable import Harbor

class SessionSpec: QuickSpec { override func spec() {
  var subject: Session!

  describe("#isActive") {
    it("is true when the expiry is in the future") {
      subject = Session(
        accessToken: Test.token(),
        expiresAt: Date(timeIntervalSinceNow: -100)
      )

      expect(subject.isActive).to(beFalse())

      subject = Session(
        accessToken: Test.token(),
        expiresAt: Date(timeIntervalSinceNow: 100)
      )

      expect(subject.isActive).to(beTrue())
    }
  }
}}
