import Foundation

protocol UserDefaults {
  func setObject(object: AnyObject?, forKey key: CustomStringConvertible)
  func objectForKey(key: CustomStringConvertible) -> AnyObject?

  func setDouble(double: Double, forKey key: CustomStringConvertible)
  func doubleForKey(key: CustomStringConvertible) -> Double

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

  func setDouble(double: Double, forKey key: CustomStringConvertible) {
    self.setDouble(double, forKey: key.description)
  }

  func doubleForKey(key: CustomStringConvertible) -> Double {
    return self.doubleForKey(key.description)
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