import Foundation
import Harbor

struct SignIn {
  func call(email: String, password: String) {
    Ui.Loading.start()

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
        Ui.Loading.stop()
        CFRunLoopStop(CFRunLoopGetCurrent())
      }

    CFRunLoopRun()
  }
}
