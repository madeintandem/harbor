@testable import Harbor

class MockKeychain : Keychain {
  enum Method : MethodType {
    case setString
    case stringForKey
  }

  var invocation: Invocation<Method>?

  func setString(_ value: String, forKey keyName: CustomStringConvertible) -> Bool {
    invocation = Invocation(.setString, value)
    return true
  }

  func stringForKey(_ keyName: CustomStringConvertible) -> String? {
    invocation = Invocation(.stringForKey, self.invocation?.value)
    return invocation?.value as! String?
  }

  func removeValueForKey(_ key: CustomStringConvertible) -> Bool {
    return false
  }
}

extension Invocations {
  static func keychain<E: Verifiable>(_ method: MockKeychain.Method, _ value: E) -> ExpectedInvocation<MockKeychain.Method, E> {
    return ExpectedInvocation(method, value)
  }
}
