import Foundation

public protocol NotificationCenter {
  func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Swift.Void) -> NSObjectProtocol
  func post(name aName: NSNotification.Name, object anObject: Any?, userInfo aUserInfo: [AnyHashable : Any]?)
}

extension Foundation.NotificationCenter : NotificationCenter {
}
