import Quick
import Nimble

@testable import Harbor

class CodeshipUserProviderSpec: QuickSpec { override func spec() {
  let subject = CodeshipUserProvider()

  describe("#save") {
    it("is correct") {
      let user = User(
        email: "ty@devmynd.com",
        password: "0pxlHC#B5&5#KJYWSRd2XEN8kS$jPH6r"
      )

      subject.save(user)
    }
  }
}}
