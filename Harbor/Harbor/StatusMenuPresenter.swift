//
//  StatusMenuPresenter.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class StatusMenuPresenter<V: StatusMenuView> : Presenter<V> {
    
    //
    // MARK: Dependencies
    //
   
    private let projectsInteractor: ProjectsInteractor
    private let settingsManager: SettingsManager
    
    //
    // MARK: Properties
    //
    
    init(
        view: V,
        projectsInteractor: ProjectsInteractor = core().inject(),
        settingsManager: SettingsManager = core().inject()) {
           
        self.projectsInteractor = projectsInteractor
        self.settingsManager = settingsManager
            
        super.init(view: view)
    }
    
    override func didInitialize() {
        super.didInitialize()
        
        self.view.createCoreMenuItems()
        self.projectsInteractor.addListener(self.handleProjects)
    }
    
    //
    // MARK: Projects
    //
    
    private func handleProjects(projects: [Project]) {
        // filter out projets the user disabled and update the view
        let disabledProjectIds = self.settingsManager.disabledProjectIds
        let enabledProjects = projects.filter { project in
            return !disabledProjectIds.contains(project.id)
        }
        
        self.view.updateProjects(enabledProjects)
        
        // determine build status and update the view
        let status = self.buildStatusFromProjects(enabledProjects)
        
        self.view.updateBuildStatus(status)
    }
    
    private func buildStatusFromProjects(projects: [Project]) -> BuildStatus {
        let failingProjects = projects.filter({ $0.status == 1 })
        
        if projects.count == 0 {
            return .Unknown
        } else if failingProjects.count == 0 {
            return .Passing
        } else {
            return .Failing
        }
    }
    
}