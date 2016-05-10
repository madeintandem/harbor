
import Foundation

class SystemModule: AppModule {
  func inject() -> UserDefaults {
    return transient {
      NSUserDefaults.standardUserDefaults() as UserDefaults
    }
  }

  func inject() -> NotificationCenter {
    return transient {
      NSNotificationCenter.defaultCenter() as NotificationCenter
    }
  }

  func inject() -> RunLoop {
    return transient {
      NSRunLoop.mainRunLoop() as RunLoop
    }
  }

  func inject() -> Keychain {
    return transient {
      KeychainWrapper() as Keychain
    }
  }
}
