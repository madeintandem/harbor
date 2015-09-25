//
//  ProjectsProvider.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

typealias ProjectHandler = ([Project] -> Void)

class ProjectsProvider {
    
    static let instance = ProjectsProvider()
    
    private var projects:  [Project]
    private var listeners: [ProjectHandler]
    
    init() {
        self.projects  = [Project]()
        self.listeners = [ProjectHandler]()
    }
    
    func refreshProjects(handler: ProjectHandler? = nil) {
        CodeshipApi.getProjects({ projects in
            self.projects = projects
            handler?(projects)
            
            for listener in self.listeners {
                listener(projects)
            }
        }, errorHandler: { error in
            debugPrint(error)
        })
    }
    
    func addHandler(aHandler: ProjectHandler){
        self.listeners.append(aHandler)
        aHandler(self.projects)
    }

}