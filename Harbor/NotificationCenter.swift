import Foundation

public protocol NotificationBus {
  func addObserverForName(name: String?, object obj: AnyObject?, queue: OperationQueue?, usingBlock block: @escaping (Notification) -> Void) -> NSObjectProtocol
  func postNotificationName(aName: String, object anObject: AnyObject?)
}

extension NotificationCenter: NotificationBus {
  public func addObserverForName(name: String?, object obj: AnyObject?, queue: OperationQueue?, usingBlock block: @escaping (Notification) -> Void) -> NSObjectProtocol {
    return addObserver(forName: name.map { NSNotification.Name($0) }, object: obj, queue: queue, using: block)
  }

  public func postNotificationName(aName: String, object anObject: AnyObject?) {
    post(name: NSNotification.Name(aName), object: anObject)
  }
}
