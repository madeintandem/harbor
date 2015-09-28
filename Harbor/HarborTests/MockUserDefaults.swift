//
//  MockUserDefaults.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor

enum Method {
    case SetObject
    case ObjectForKey
    case SetDouble
    case DoubleForKey
}

class MockUserDefaults : UserDefaults {
    
    var objectInvocation: Invocation<AnyObject>?
    var doubleInvocation: Invocation<Double>?
    
    func setObject(object: AnyObject?, forKey key: String) {
        self.objectInvocation = Invocation(.SetObject, object)
    }
    
    func objectForKey(key: String) -> AnyObject? {
        let lastValue = self.objectInvocation?.value
        self.objectInvocation = Invocation(.ObjectForKey, lastValue)
        return lastValue
    }
    
    func setDouble(double: Double, forKey key: String) {
        self.doubleInvocation = Invocation(.SetDouble, double)
    }
    
    func doubleForKey(key: String) -> Double {
        let lastValue = self.doubleInvocation?.value
        self.doubleInvocation = Invocation(.DoubleForKey, lastValue)
        return lastValue != nil ? lastValue! : 0.0
    }
    
}
