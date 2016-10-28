@testable import Harbor

class MockPreferencesView : PreferencesView {
  var refreshRateError: String?
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
    refreshRateError = errorMessage
  }
}
