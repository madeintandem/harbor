@testable import Harbor

import Foundation

class MockRunLoop : RunLoop {
  enum Method : MethodType {
    case AddTimer
  }

  var invocation: Invocation<Method>?

  func addTimer(timer: NSTimer, forMode mode: String){
    invocation = Invocation(.AddTimer, timer)
  }
}

extension Invocations {
  static func runloop<E: Verifiable>(method: MockRunLoop.Method, _ value: E?) -> ExpectedInvocation<MockRunLoop.Method, E> {
    return ExpectedInvocation(method, value)
  }
}