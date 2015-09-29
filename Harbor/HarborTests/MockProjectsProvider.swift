//
//  MockProjectsProvider.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/29/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

@testable import Harbor

class MockProjectsProvider : ProjectsInteractor {
    
    enum Method : MethodType {
        case RefreshProjects
        case RefreshCurrentProjects
        case AddHandler
    }
    
    let projects  : [Project]
    var invocation: Invocation<Method, None>?

    init() {
        self.projects = MockCodeshipApi().generateProjects()
    }
    
    func refreshProjects(){
        self.invocation = Invocation(.RefreshProjects, .Nothing)
    }
    
    func refreshCurrentProjects(){
        self.invocation = Invocation(.RefreshCurrentProjects, .Nothing)
    }
    
    func addHandler(aHandler: ProjectHandler){
        self.invocation = Invocation(.AddHandler, .Nothing)
        aHandler(self.projects)
    }
}
