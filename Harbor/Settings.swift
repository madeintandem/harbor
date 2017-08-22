import Foundation
import ServiceManagement
import CoreServices

class Settings: SettingsType {
  fileprivate enum Key: String, CustomStringConvertible {
    case ApiKey           = "ApiKey"
    case RefreshRate      = "RefreshRate"
    case DisabledProjects = "DisabledProjects"
    case LaunchOnLogin    = "LaunchOnLogin"
    case HasLaunched      = "HasLaunched"

    var description: String {
      get { return rawValue }
    }

    var storedInKeychain: Bool {
      get { return self == .ApiKey }
    }

    static func all() -> [Key] {
      return [ .ApiKey, .RefreshRate, .DisabledProjects, .LaunchOnLogin, .HasLaunched ]
    }
  }

  //
  // MARK: Dependencies
  fileprivate let defaults:           UserDefaults
  fileprivate let keychain:           Keychain
  fileprivate let notificationCenter: NotificationCenter

  //
  // MARK: Properties
  var apiKey: String {
    didSet {
      keychain.setString(apiKey, forKey: Key.ApiKey)
      postNotification(.ApiKey)
    }
  }

  var refreshRate: Int {
    didSet {
      defaults.setInteger(refreshRate, forKey: Key.RefreshRate)
      postNotification(.RefreshRate)
    }
  }

  var disabledProjectIds: [Int] {
    didSet {
      defaults.setObject(disabledProjectIds, forKey: Key.DisabledProjects)
      postNotification(.DisabledProjects)
    }
  }

  var launchOnLogin: Bool {
    didSet {
      defaults.setBool(launchOnLogin, forKey: Key.LaunchOnLogin)
      if oldValue != launchOnLogin {
        updateHelperLoginItem(launchOnLogin)
      }
    }
  }

  var isFirstRun: Bool
  fileprivate let defaultRefreshRate: Int = 60

  init(defaults: UserDefaults, keychain: Keychain, notificationCenter: NotificationCenter) {
    self.defaults           = defaults
    self.keychain           = keychain
    self.notificationCenter = notificationCenter

    apiKey             = keychain.stringForKey(Key.ApiKey) ?? ""
    refreshRate        = (defaults.integerForKey(Key.RefreshRate) > 0) ? defaults.integerForKey(Key.RefreshRate) : defaultRefreshRate
    disabledProjectIds = defaults.objectForKey(Key.DisabledProjects) as? [Int] ?? [Int]()
    isFirstRun         = !defaults.boolForKey(Key.HasLaunched)
    launchOnLogin      = isFirstRun ? true : defaults.boolForKey(Key.LaunchOnLogin)
  }

  func startup() {
    // on first run, update the login item immediately and mark the app as launched
    if isFirstRun {
      defaults.setBool(true, forKey: Key.HasLaunched)
      updateHelperLoginItem(launchOnLogin)
    }
  }

  func reset() {
    // clear out values for all the stored keys
    for key in Key.all() {
      if key.storedInKeychain {
        keychain.removeValueForKey(key)
      } else {
        defaults.removeValueForKey(key)
      }
    }
  }

  fileprivate func updateHelperLoginItem(_ launchOnLogin: Bool) {
    let result = SMLoginItemSetEnabled("com.dvm.Harbor.Helper" as CFString, launchOnLogin)
    let enabled = launchOnLogin ? "enabling" : "disabling"
    let success = result ? "succeeded" : "failed"
    print("\(enabled) launch on login \(success)")
  }
}

//
// MARK: Notifications
extension Settings {
  func observeNotification(_ notification: SettingsNotification, handler: ((Notification) -> Void)) -> NSObjectProtocol {
    return notificationCenter.addObserverForName(notification.rawValue, object: nil, queue: nil, usingBlock: handler)
  }

  fileprivate func postNotification(_ notification: SettingsNotification) {
    notificationCenter.postNotificationName(notification.rawValue, object: nil)
  }
}
