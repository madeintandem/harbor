//
//  NotificationCenter.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

public protocol NotificationCenter {
    func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol

    func postNotificationName(aName: String, object anObject: AnyObject?)
}

extension NSNotificationCenter : NotificationCenter {
    
}