import Foundation

@testable import Harbor

class MockNotificationCenter : NotificationCenter {
  enum Method : MethodType {
    case AddObserverForName
    case PostNotificationName
  }

  var invocation: Invocation<Method>?

  func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol {
    invocation = Invocation(.AddObserverForName, name)
    return name! as NSString
  }

  func postNotificationName(aName: String, object anObject: AnyObject?){
    invocation = Invocation(.PostNotificationName, aName)
  }
}

extension Invocations {
  static func notification(method: MockNotificationCenter.Method, _ key: SettingsManager.NotificationName) -> ExpectedInvocation<MockNotificationCenter.Method, VerifierOf> {
    return ExpectedInvocation(method, VerifierOf(key.rawValue))
  }
}