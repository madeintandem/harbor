import Foundation

protocol PreferencesView : ViewType {
  func updateProjects(_ projects: [Project])
  func updateRefreshRate(_ refreshRate: String)
  func updateApiKey(_ apiKey: String)
  func updateLaunchOnLogin(_ launchOnLogin: Bool)
  func updateApiKeyError(_ errorMessage: String)
  func updateRefreshRateError(_ errorMessage: String)
}
