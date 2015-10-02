//
//  StatusMenuView.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

protocol StatusMenuView : ViewType {
    func createCoreMenuItems()
    func updateBuildStatus(status: BuildStatus)
    func updateProjects(projects: [ProjectMenuItemModel])
}
