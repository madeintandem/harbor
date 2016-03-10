//
//  ProjectMenuItemModel.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

struct ProjectMenuItemModel {
    
    private let project: Project
   
    init(project: Project) {
        self.project = project
    }
    
    //
    // MARK: Display
    //
    
    var title: String {
        get { return self.project.repositoryName }
    }
    
    var submenuTitle: String {
        get { return "Builds" }
    }
    
    //
    // MARK: Status
    //
    
    var status: BuildStatus {
        return self.project.status == 0 ? .Passing : .Failing
    }
    
    var isFailing: Bool {
        get { return self.status == .Failing }
    }
    
    //
    // MARK: Children
    //
    
    func builds() -> [BuildViewModel] {
        return self.project.builds.map { build in
            return BuildViewModel(build: build, projectId: self.project.id)
        }
    }
 
}
