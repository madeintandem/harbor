
import Foundation

protocol SettingsType {
  var apiKey: String { get set }
  var refreshRate: Int { get set }
  var disabledProjectIds: [Int] { get set }
  var launchOnLogin: Bool { get set }
  var isFirstRun: Bool { get set }

  func startup()
  func reset()

  func observeNotification(_ notification: SettingsNotification, handler: @escaping (Notification) -> Void) -> NSObjectProtocol
}

// MARK: Notifications
enum SettingsNotification: String {
  case ApiKey           = "ApiKey"
  case RefreshRate      = "RefreshRate"
  case DisabledProjects = "DisabledProjects"
}
