//
//  MockRunLoop.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor
import Foundation

class MockRunLoop : RunLoop {
    
    enum Method : MethodType {
        case AddTimer
    }
    
    var invocation: Invocation<Method, NSTimer>?
    
    func addTimer(timer: NSTimer, forMode mode: String){
        invocation = Invocation(.AddTimer, timer)
        
    }
}