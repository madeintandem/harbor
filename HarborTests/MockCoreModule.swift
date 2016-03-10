@testable import Harbor

struct MockCoreModule : CoreModuleType {
  //
  // Interactors
  //

  func inject() -> SettingsManager {
    return single { SettingsManager() }
  }

  func inject() -> ProjectsInteractor {
    return single { MockProjectsProvider() }
  }

  func inject() -> TimerCoordinator {
    return single { TimerCoordinator() }
  }

  //
  // Services
  //

  func inject() -> CodeshipApiType {
    return single { MockCodeshipApi() }
  }

  //
  // Foundation
  //

  func inject() -> UserDefaults {
    return single { MockUserDefaults() }
  }

  func inject() -> NotificationCenter {
    return single { MockNotificationCenter() }
  }

  func inject() -> RunLoop {
    return single { MockRunLoop() }
  }

  //
  // Utilities
  //

  func inject() -> Keychain {
    return single { MockKeychain() }
  }
}