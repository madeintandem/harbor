@testable import Harbor

class MockPreferencesView : PreferencesView {
  var refreshRateError: String?
  var apiKey: String?

  func updateProjects(_ projects: [Project]) {
  }

  func updateRefreshRate(_ refreshRate: String) {
  }

  func updateApiKey(_ apiKey: String) {
    self.apiKey = apiKey
  }

  func updateLaunchOnLogin(_ launchOnLogin: Bool) {
  }

  func updateApiKeyError(_ errorMessage: String) {
  }

  func updateRefreshRateError(_ errorMessage: String) {
    refreshRateError = errorMessage
  }
}
