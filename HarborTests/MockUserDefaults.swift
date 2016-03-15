@testable import Harbor

class MockUserDefaults : UserDefaults {
  enum Method : MethodType {
    case SetObject
    case ObjectForKey
    case SetDouble
    case DoubleForKey
  }

  var invocation: Invocation<Method>?

  func setObject(object: AnyObject?, forKey key: CustomStringConvertible) {
    invocation = Invocation(.SetObject, object)
  }

  func objectForKey(key: CustomStringConvertible) -> AnyObject? {
    let lastValue = invocation?.value
    invocation = Invocation(.ObjectForKey, lastValue)
    return lastValue as! AnyObject?
  }

  func setDouble(double: Double, forKey key: CustomStringConvertible) {
    invocation = Invocation(.SetDouble, double)
  }

  func doubleForKey(key: CustomStringConvertible) -> Double {
    let lastValue = invocation?.value
    invocation = Invocation(.DoubleForKey, lastValue)
    return lastValue as? Double ?? 0.0
  }

  func setBool(bool: Bool, forKey key: CustomStringConvertible) {

  }

  func boolForKey(key: CustomStringConvertible) -> Bool {
    return false
  }

  func removeValueForKey(key: CustomStringConvertible) {

  }
}

extension Invocations {
  static func defaults<E: Verifiable>(method: MockUserDefaults.Method, _ value: E) -> ExpectedInvocation<MockUserDefaults.Method, E> {
    return ExpectedInvocation(method, value)
  }
}