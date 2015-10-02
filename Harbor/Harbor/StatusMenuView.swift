//
//  StatusMenuView.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

enum BuildStatus : String {
    case Unknown = "codeshipLogo_black"
    case Passing = "codeshipLogo_green"
    case Failing = "codeshipLogo_red"
}

protocol StatusMenuView : ViewType {
    func createCoreMenuItems()
    func updateBuildStatus(status: BuildStatus)
    func updateProjects(projects: [Project])
}
