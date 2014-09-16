//
//  Project.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Foundation
class Project : NSObject{
    var id: Int?
    var repositoryName: String?
    var builds: [Build] = []
    var active: Bool?
    
    override init(){
        super.init()
    }
    
    init(id: Int,
        repositoryName: String){
            self.id = id
            self.repositoryName = repositoryName
            super.init()
    }
}