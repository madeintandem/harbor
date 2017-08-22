import Foundation

public protocol NotificationCenter {
  func addObserverForName(_ name: String?, object obj: AnyObject?, queue: OperationQueue?, usingBlock block: (Notification) -> Void) -> NSObjectProtocol
  func postNotificationName(_ aName: String, object anObject: AnyObject?)
}

extension Foundation.NotificationCenter : NotificationCenter {

}
