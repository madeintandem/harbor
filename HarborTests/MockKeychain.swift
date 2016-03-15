@testable import Harbor

class MockKeychain : Keychain {
  enum Method : MethodType {
    case SetString
    case StringForKey
  }

  var invocation: Invocation<Method>?

  func setString(value: String, forKey keyName: CustomStringConvertible) -> Bool {
    invocation = Invocation(.SetString, value)
    return true
  }

  func stringForKey(keyName: CustomStringConvertible) -> String? {
    invocation = Invocation(.StringForKey, self.invocation?.value)
    return invocation?.value as! String?
  }

  func removeValueForKey(key: CustomStringConvertible) -> Bool {
    return false
  }
}

extension Invocations {
  static func keychain<E: Verifiable>(method: MockKeychain.Method, _ value: E) -> ExpectedInvocation<MockKeychain.Method, E> {
    return ExpectedInvocation(method, value)
  }
}