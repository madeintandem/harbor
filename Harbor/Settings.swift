import Foundation
import ServiceManagement
import CoreServices

class Settings: SettingsType {
  private enum Key: String, CustomStringConvertible {
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

  // MARK: Dependencies
  private let defaults:        KeyValueStore
  private let keychain:        Keychain
  private let notificationBus: NotificationBus

  // MARK: Properties
  var apiKey: String {
    didSet {
      _ = keychain.setString(value: apiKey, forKey: Key.ApiKey)
      postNotification(.ApiKey)
    }
  }

  var refreshRate: Int {
    didSet {
      defaults.setInteger(integer: refreshRate, forKey: Key.RefreshRate)
      postNotification(.RefreshRate)
    }
  }

  var disabledProjectIds: [Int] {
    didSet {
      defaults.setObject(object: disabledProjectIds as AnyObject?, forKey: Key.DisabledProjects)
      postNotification(.DisabledProjects)
    }
  }

  var launchOnLogin: Bool {
    didSet {
      defaults.setBool(bool: launchOnLogin, forKey: Key.LaunchOnLogin)
      if oldValue != launchOnLogin {
        updateHelperLoginItem(launchOnLogin: launchOnLogin)
      }
    }
  }

  var isFirstRun: Bool
  private let defaultRefreshRate: Int = 60

  init(defaults: KeyValueStore, keychain: Keychain, notificationBus: NotificationBus) {
    self.defaults        = defaults
    self.keychain        = keychain
    self.notificationBus = notificationBus

    apiKey             = keychain.stringForKey(keyName: Key.ApiKey) ?? ""
    refreshRate        = (defaults.integerForKey(key: Key.RefreshRate) > 0) ? defaults.integerForKey(key: Key.RefreshRate) : defaultRefreshRate
    disabledProjectIds = defaults.objectForKey(key: Key.DisabledProjects) as? [Int] ?? [Int]()
    isFirstRun         = !defaults.boolForKey(key: Key.HasLaunched)
    launchOnLogin      = isFirstRun ? true : defaults.boolForKey(key: Key.LaunchOnLogin)
  }

  func startup() {
    // on first run, update the login item immediately and mark the app as launched
    if isFirstRun {
      defaults.setBool(bool: true, forKey: Key.HasLaunched)
      updateHelperLoginItem(launchOnLogin: launchOnLogin)
    }
  }

  func reset() {
    // clear out values for all the stored keys
    for key in Key.all() {
      if key.storedInKeychain {
        _ = keychain.removeValueForKey(key: key)
      } else {
        defaults.removeValueForKey(key: key)
      }
    }
  }

  private func updateHelperLoginItem(launchOnLogin: Bool) {
    let result = SMLoginItemSetEnabled("com.dvm.Harbor.Helper" as CFString, launchOnLogin)
    let enabled = launchOnLogin ? "enabling" : "disabling"
    let success = result ? "succeeded" : "failed"
    print("\(enabled) launch on login \(success)")
  }

  // MARK: Notifications
  func observeNotification(_ notification: SettingsNotification, handler: @escaping (Notification) -> Void) -> NSObjectProtocol {
    return notificationBus.addObserverForName(name: notification.rawValue, object: nil, queue: nil, usingBlock: handler)
  }

  private func postNotification(_ notification: SettingsNotification) {
    notificationBus.postNotificationName(aName: notification.rawValue, object: nil)
  }
}
