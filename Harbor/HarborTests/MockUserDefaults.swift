//
//  MockUserDefaults.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

@testable import Harbor

class MockUserDefaults : UserDefaults {
    
    enum Method : MethodType {
        case SetObject
        case ObjectForKey
        case SetDouble
        case DoubleForKey
    }
    
    var objectInvocation: Invocation<Method, AnyObject>?
    var doubleInvocation: Invocation<Method, Double>?
    
    func setObject(object: AnyObject?, forKey key: CustomStringConvertible) {
        self.objectInvocation = Invocation(.SetObject, object)
    }
    
    func objectForKey(key: CustomStringConvertible) -> AnyObject? {
        let lastValue = self.objectInvocation?.value
        self.objectInvocation = Invocation(.ObjectForKey, lastValue)
        return lastValue
    }
    
    func setDouble(double: Double, forKey key: CustomStringConvertible) {
        self.doubleInvocation = Invocation(.SetDouble, double)
    }
    
    func doubleForKey(key: CustomStringConvertible) -> Double {
        let lastValue = self.doubleInvocation?.value
        self.doubleInvocation = Invocation(.DoubleForKey, lastValue)
        return lastValue != nil ? lastValue! : 0.0
    }
    
    func setBool(bool: Bool, forKey key: CustomStringConvertible) {
    
    }
    
    func boolForKey(key: CustomStringConvertible) -> Bool {
        return false
    }
    
    func removeValueForKey(key: CustomStringConvertible) {
    
    }
    
}
