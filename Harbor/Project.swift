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
        println("we have an empty project");
        super.init()
    }
    
    init(id: Int,
        repositoryName: String,
        builds: [Build]){
            self.id = id
            self.repositoryName = repositoryName
            self.builds = builds
            
            super.init()
    }
}