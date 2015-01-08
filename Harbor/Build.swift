//
//  Build.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Foundation
class Build : NSObject{
    var id: Int?
    var uuid: String?
    var status: String?
    var commitId: String?
    var message: String?
    var branch: String?
    var date: NSDate?
 
    override init(){
        super.init()
    }
    
    init(id: Int,
        uuid: String,
        status: String,
        commitId: String,
        message: String,
        branch: String
        ){
            self.id = id
            self.uuid = uuid
            self.status = status
            self.commitId = commitId
            self.message = message
            self.branch = branch
            
            super.init()
    }
    
    func generateDate() -> NSDate {
        return NSDate()
    }
}