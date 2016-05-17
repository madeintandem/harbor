import Foundation

protocol PreferencesView : ViewType {
  func updateProjects(projects: [Project])
  func updateRefreshRate(refreshRate: String)
  func updateApiKey(apiKey: String)
  func updateLaunchOnLogin(launchOnLogin: Bool)
  func updateApiKeyError(errorMessage: String)
  func updateRefreshRateError(errorMessage: String)
}