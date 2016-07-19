@testable import Harbor

class MockPreferencesView : PreferencesView {
  init() {
    
  }

  var apiKey: String?

  func updateProjects(projects: [Project]) {
    
  }

  func updateRefreshRate(refreshRate: String) {
    
  }

  func updateApiKey(apiKey: String) {
    self.apiKey = apiKey
  }

  func updateLaunchOnLogin(launchOnLogin: Bool) {

  }

  func updateApiKeyError(errorMessage: String) {

  }

  func updateRefreshRateError(errorMessage: String) {

  }
}
