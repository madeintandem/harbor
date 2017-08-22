
import Foundation

class SystemModule: AppModule {
  func inject() -> UserDefaults {
    return transient {
      Foundation.UserDefaults.standardUserDefaults() as UserDefaults
    }
  }

  func inject() -> NotificationCenter {
    return transient {
      Foundation.NotificationCenter.defaultCenter() as NotificationCenter
    }
  }

  func inject() -> RunLoop {
    return transient {
      Foundation.RunLoop.mainRunLoop() as RunLoop
    }
  }

  func inject() -> Keychain {
    return transient {
      KeychainWrapper() as Keychain
    }
  }
}
