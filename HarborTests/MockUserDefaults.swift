@testable import Harbor

class MockUserDefaults : UserDefaults {
  enum Method : MethodType {
    case setObject
    case objectForKey
    case setInteger
    case integerForKey
  }

  var invocation: Invocation<Method>?

  func setObject(_ object: AnyObject?, forKey key: CustomStringConvertible) {
    invocation = Invocation(.setObject, object)
  }

  func objectForKey(_ key: CustomStringConvertible) -> AnyObject? {
    let lastValue = invocation?.value
    invocation = Invocation(.objectForKey, lastValue)
    return lastValue as AnyObject?
  }

  func setInteger(_ integer: Int, forKey key: CustomStringConvertible) {
    invocation = Invocation(.setInteger, integer)
  }

  func integerForKey(_ key: CustomStringConvertible) -> Int {
    let lastValue = invocation?.value
    invocation = Invocation(.integerForKey, lastValue)
    return lastValue as? Int ?? 0
  }

  func setBool(_ bool: Bool, forKey key: CustomStringConvertible) {

  }

  func boolForKey(_ key: CustomStringConvertible) -> Bool {
    return false
  }

  func removeValueForKey(_ key: CustomStringConvertible) {

  }
}

extension Invocations {
  static func defaults<E: Verifiable>(_ method: MockUserDefaults.Method, _ value: E) -> ExpectedInvocation<MockUserDefaults.Method, E> {
    return ExpectedInvocation(method, value)
  }
}
