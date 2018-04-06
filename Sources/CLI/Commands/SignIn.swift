import Foundation
import Harbor

struct SignIn {
  func call(email: String, password: String) {
    Ui.loading()

    User.SignIn()
      .call(
        email: email,
        password: password
      )
      .onSuccess { user in
        Ui.info("signed in: \(user.email)")
      }
      .onFailure { error in
        Ui.error("sign in failed: \(error)")
      }
      .onComplete { _ in
        CFRunLoopStop(CFRunLoopGetCurrent())
      }

    CFRunLoopRun()
  }
}
