//
//  Account.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Foundation
class Account : NSObject{
    var key: String?
    var projects: [Project] = []
    
    override init(){
        print("made an account")
        super.init()
    }
    
    func currentProjects() -> [Project] {
        
        return projects
    }
}