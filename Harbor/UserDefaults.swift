import Foundation

protocol UserDefaults {
  func setObject(_ object: AnyObject?, forKey key: CustomStringConvertible)
  func objectForKey(_ key: CustomStringConvertible) -> AnyObject?

  func setInteger(_ integer: Int, forKey key: CustomStringConvertible)
  func integerForKey(_ key: CustomStringConvertible) -> Int

  func setBool(_ bool: Bool, forKey key: CustomStringConvertible)
  func boolForKey(_ key: CustomStringConvertible) -> Bool

  func removeValueForKey(_ key: CustomStringConvertible)
}

extension Foundation.UserDefaults : UserDefaults {
  func setObject(_ object: AnyObject?, forKey key: CustomStringConvertible) {
    self.set(object, forKey: key.description)
  }

  func objectForKey(_ key: CustomStringConvertible) -> AnyObject? {
    return self.object(forKey: key.description) as AnyObject
  }

  func setInteger(_ integer: Int, forKey key: CustomStringConvertible) {
    if let currentObject = object(forKey: key.description) {
      if currentObject is Double {
        removeObject(forKey: key.description)
      }
    }
    self.set(integer, forKey: key.description)
  }

  func integerForKey(_ key: CustomStringConvertible) -> Int {
    return self.integer(forKey: key.description)
  }

  func setBool(_ bool: Bool, forKey key: CustomStringConvertible) {
    self.set(bool, forKey: key.description)
  }

  func boolForKey(_ key: CustomStringConvertible) -> Bool {
    return self.bool(forKey: key.description)
  }

  func removeValueForKey(_ key: CustomStringConvertible) {
    self.removeObject(forKey: key.description)
  }
}
