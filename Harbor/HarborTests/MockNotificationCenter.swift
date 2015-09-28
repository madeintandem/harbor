//
//  MockNotificationCenter.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Harbor

class MockNotificationCenter : NotificationCenter {
    
    enum Method : MethodType {
        case AddObserverForName
        case PostNotificationName
    }
    
    var invocation: Invocation<Method, String>?
    
    func addObserverForName(name: String?, object obj: AnyObject?, queue: NSOperationQueue?, usingBlock block: (NSNotification) -> Void) -> NSObjectProtocol {
        invocation = Invocation(.AddObserverForName, name)
        return name! as NSString
    }
    
    func postNotificationName(aName: String, object anObject: AnyObject?){
        invocation = Invocation(.PostNotificationName, aName)
    }
}
