//
//  MockCodeshipApi.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor

class MockCodeshipApi : CodeshipApiType {

    var projects: [Project]?
    
    init() {
        
    }
    
    func getProjects(successHandler:([Project]) -> (), errorHandler:(String) -> ()) {
        if let projects = self.projects {
            successHandler(projects)
        } else {
            errorHandler("nope")
        }
    }
    
    func mockProjects() {
        self.projects = self.generateProjects()
    }
    
    func generateProjects() -> [Project] {
        return (0...10).map { Project(id: $0) }
    }
    
}

