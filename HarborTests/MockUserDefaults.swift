@testable import Harbor

class MockUserDefaults : UserDefaults {
  enum Method : MethodType {
    case SetObject
    case ObjectForKey
    case SetInteger
    case IntegerForKey
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

  func setInteger(integer: Int, forKey key: CustomStringConvertible) {
    invocation = Invocation(.SetInteger, integer)
  }

  func integerForKey(key: CustomStringConvertible) -> Int {
    let lastValue = invocation?.value
    invocation = Invocation(.IntegerForKey, lastValue)
    return lastValue as? Int ?? 0
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