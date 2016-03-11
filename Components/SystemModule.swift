import Foundation

class SystemModule: AppModule {
  func inject() -> UserDefaults {
    return transient {
      NSUserDefaults.standardUserDefaults()
    }
  }

  func inject() -> NotificationCenter {
    return transient {
      NSNotificationCenter.defaultCenter()
    }
  }

  func inject() -> RunLoop {
    return transient {
      NSRunLoop.mainRunLoop()
    }
  }

  func inject() -> Keychain {
    return transient {
      KeychainWrapper()
    }
  }
}