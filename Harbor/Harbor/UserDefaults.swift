//
//  UserDefaults.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

public protocol UserDefaults {
    func setObject(object: AnyObject?, forKey key: String)
    func objectForKey(key: String) -> AnyObject?
    
    func setDouble(double: Double, forKey key: String)
    func doubleForKey(key: String) -> Double
}

extension NSUserDefaults : UserDefaults {
    
}
