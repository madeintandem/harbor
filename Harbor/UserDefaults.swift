import Foundation

protocol UserDefaults {
  func setObject(object: AnyObject?, forKey key: CustomStringConvertible)
  func objectForKey(key: CustomStringConvertible) -> AnyObject?

  func setInteger(integer: Int, forKey key: CustomStringConvertible)
  func integerForKey(key: CustomStringConvertible) -> Int

  func setBool(bool: Bool, forKey key: CustomStringConvertible)
  func boolForKey(key: CustomStringConvertible) -> Bool

  func removeValueForKey(key: CustomStringConvertible)
}

extension NSUserDefaults : UserDefaults {
  func setObject(object: AnyObject?, forKey key: CustomStringConvertible) {
    self.setObject(object, forKey: key.description)
  }

  func objectForKey(key: CustomStringConvertible) -> AnyObject? {
    return self.objectForKey(key.description)
  }

  func setInteger(integer: Int, forKey key: CustomStringConvertible) {
    if let currentObject = objectForKey(key.description) {
      if currentObject is Double {
        removeObjectForKey(key.description)
      }
    }
    self.setInteger(integer, forKey: key.description)
  }

  func integerForKey(key: CustomStringConvertible) -> Int {
    return self.integerForKey(key.description)
  }

  func setBool(bool: Bool, forKey key: CustomStringConvertible) {
    self.setBool(bool, forKey: key.description)
  }

  func boolForKey(key: CustomStringConvertible) -> Bool {
    return self.boolForKey(key.description)
  }

  func removeValueForKey(key: CustomStringConvertible) {
    self.removeObjectForKey(key.description)
  }
}