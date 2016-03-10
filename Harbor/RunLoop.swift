//
//  RunLoop.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

public protocol RunLoop {
    func addTimer(timer: NSTimer, forMode mode: String)
}

extension NSRunLoop : RunLoop {
    
}
