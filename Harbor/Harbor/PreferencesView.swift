//
//  PreferencesView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/23/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

protocol PreferencesView : ViewType {
    func updateProjects(projects: [Project])
    func updateRefreshRate(refreshRate: String)
    func updateApiKey(apiKey: String)
    func updateLaunchOnLogin(launchOnLogin: Bool)
}
