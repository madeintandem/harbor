@testable import Harbor
import Foundation

class MockSettings: SettingsType {
  var apiKey: String = ""
  var refreshRate: Double = 0.0
  var disabledProjectIds: [Int] = []
  var launchOnLogin: Bool = false
  var isFirstRun: Bool = false

  func startup() {
  }

  func reset() {
  }

  func observeNotification(notification: SettingsNotification, handler: (NSNotification -> Void)) -> NSObjectProtocol {
    return NSObject()
  }
}
