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
    
    static let instance = ProjectsProvider(
        codeshipApi: CodeshipApi(),
        settingsManager: SettingsManager.instance
    )
    
    private var projects:  [Project]
    private var listeners: [ProjectHandler]
    private let settingsManager: SettingsManager
    private let codeshipApi: CodeshipApiType
    
    init(codeshipApi: CodeshipApiType, settingsManager: SettingsManager) {
        self.projects  =   [Project]()
        self.listeners =   [ProjectHandler]()
        self.codeshipApi = codeshipApi
        self.settingsManager = settingsManager
        
        self.settingsManager.observeNotification(.ApiKey) { _ in
            self.refreshProjects()
        }
        
        self.settingsManager.observeNotification(.DisabledProjects) { _ in
            self.refreshCurrentProjects()
        }
    }
    
    func refreshProjects() {
        self.codeshipApi.getProjects(didRefreshProjects, errorHandler: { error in
            debugPrint(error)
        })
    }
    
    func refreshCurrentProjects() {
        self.didRefreshProjects(self.projects)
    }
    
    private func didRefreshProjects(projects: [Project]){
        // update our projects hidden state appropriately according to the user settings
        for project in projects {
            project.isEnabled = !self.settingsManager.disabledProjectIds.contains(project.id)
        }
        
        self.projects = projects
        
        for listener in self.listeners {
            listener(projects)
        }
    }
    
    func addHandler(aHandler: ProjectHandler){
        self.listeners.append(aHandler)
        aHandler(self.projects)
    }
    
}