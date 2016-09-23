@testable import Harbor

import Foundation

class MockNotificationCenter : NotificationCenter {
  enum Method : MethodType {
    case addObserverForName
    case postNotificationName
  }

  var invocation: Invocation<Method>?

  func addObserverForName(_ name: String?, object obj: AnyObject?, queue: OperationQueue?, usingBlock block: (Notification) -> Void) -> NSObjectProtocol {
    invocation = Invocation(.addObserverForName, name)
    return name! as NSString
  }

  func postNotificationName(_ aName: String, object anObject: AnyObject?){
    invocation = Invocation(.postNotificationName, aName)
  }
}

extension Invocations {
  static func notification(_ method: MockNotificationCenter.Method, _ key: SettingsNotification) -> ExpectedInvocation<MockNotificationCenter.Method, VerifierOf> {
    return ExpectedInvocation(method, VerifierOf(key.rawValue))
  }
}
