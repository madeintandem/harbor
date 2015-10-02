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
        case AddListener
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
    
    func addListener(listener: ProjectHandler){
        self.invocation = Invocation(.AddListener, .Nothing)
        listener(self.projects)
    }
}
