
import Foundation

class SystemModule: AppModule {
  func inject() -> KeyValueStore {
    return transient {
      UserDefaults.standard as KeyValueStore
    }
  }

  func inject() -> NotificationBus {
    return transient {
      NotificationCenter.default as NotificationBus
    }
  }

  func inject() -> Scheduler {
    return transient {
      RunLoop.main as Scheduler
    }
  }

  func inject() -> Keychain {
    return transient {
      KeychainWrapper() as Keychain
    }
  }
}
