@testable import Harbor
import Foundation

class MockSettings: SettingsType {
  var apiKey: String = ""
  var refreshRate: Int = 0
  var disabledProjectIds: [Int] = []
  var launchOnLogin: Bool = false
  var isFirstRun: Bool = false

  func startup() {
  }

  func reset() {
  }

  func observeNotification(_ notification: SettingsNotification, handler: ((Notification) -> Void)) -> NSObjectProtocol {
    return NSObject()
  }
}
