import Foundation

protocol KeyValueStore {
  func setObject(object: AnyObject?, forKey key: CustomStringConvertible)
  func objectForKey(key: CustomStringConvertible) -> Any?

  func setInteger(integer: Int, forKey key: CustomStringConvertible)
  func integerForKey(key: CustomStringConvertible) -> Int

  func setBool(bool: Bool, forKey key: CustomStringConvertible)
  func boolForKey(key: CustomStringConvertible) -> Bool

  func removeValueForKey(key: CustomStringConvertible)
}

extension UserDefaults: KeyValueStore {
  func setObject(object: AnyObject?, forKey key: CustomStringConvertible) {
    set(object, forKey: key.description)
  }

  func objectForKey(key: CustomStringConvertible) -> Any? {
    return object(forKey: key.description)
  }

  func setInteger(integer: Int, forKey key: CustomStringConvertible) {
    if let currentObject = object(forKey: key.description) {
      if currentObject is Double {
        removeObject(forKey: key.description)
      }
    }
    set(integer, forKey: key.description)
  }

  func integerForKey(key: CustomStringConvertible) -> Int {
    return integer(forKey: key.description)
  }

  func setBool(bool: Bool, forKey key: CustomStringConvertible) {
    set(bool, forKey: key.description)
  }

  func boolForKey(key: CustomStringConvertible) -> Bool {
    return bool(forKey: key.description)
  }

  func removeValueForKey(key: CustomStringConvertible) {
    removeObject(forKey: key.description)
  }
}
