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
        
        self.projectsInteractor.addListener { projects in
            
        }
    }

    
}