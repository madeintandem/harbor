import Foundation

public protocol NotificationCenter {
  func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol
  func postNotificationName(aName: String, object anObject: AnyObject?)
}

extension NSNotificationCenter : NotificationCenter {

}