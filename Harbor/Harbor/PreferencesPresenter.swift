//
//  PreferencesPresenter.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/23/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Cocoa

class PreferencesPresenter {
    
    //
    // MARK: Properties
    //
    
    private weak var view: PreferencesView!

    private var apiKey:       String = ""
    private var refreshRate:  Double = 60.0
    private var needsRefresh: Bool   = true
    private var allProjects:  [Project]

    init(view: PreferencesView) {
        self.view = view
        self.allProjects = [Project]()
    }
    
    //
    // MARK: Presentation Cycle
    //
    
    func didBecomeActive() {
        self.refreshIfNecessary()
    }
    
    func didResignActive() {
        self.refreshIfNecessary()
    }
    
    private func refreshIfNecessary() {
        if(self.needsRefresh) {
            self.refreshConfiguration()
            self.refreshProjects()
            
            self.needsRefresh = false
        }
    }
    
    private func setNeedsRefresh() {
        if(!self.needsRefresh) {
            self.needsRefresh = true
        }
    }
    
    //
    // MARK: Preferences
    //
    
    func savePreferences() {
        if self.apiKey.isEmpty {
            return
        }
        
        // serialize our configuration
        KeychainWrapper.setString(self.apiKey, forKey: "APIKey")
        defaults.setObject(self.refreshRate, forKey: "refreshRate")
        
        // serialize the hidden projects
        let hiddenProjectIds = self.allProjects.reduce([Int]()) { (var memo, project) in
            memo.append(project.id)
            return memo
        }
        
        defaults.setObject(hiddenProjectIds, forKey: "hiddenProjects")
        
        self.needsRefresh = false
//        CodeshipApi.getProjects(handleGetProjectsRequest, errorHandler: handleGetProjectsError)
//        (NSApplication.sharedApplication().delegate as! AppDelegate).setupTimer(refreshRateTextField.doubleValue)
    }
    
    func updateApiKey(apiKey: String) {
        self.apiKey = apiKey
        self.setNeedsRefresh()
    }
    
    func updateRefreshRate(refreshRate: String) {
        self.refreshRate = (refreshRate as NSString).doubleValue
        self.setNeedsRefresh()
    }
    
    private func refreshConfiguration() {
        // load data from user defaults
        self.refreshRate = self.defaults.doubleForKey("refreshRate")
        if let apiKey = KeychainWrapper.stringForKey("APIKey") {
            self.apiKey = apiKey
        }
        
        // update our view after refreshing
        self.view.updateApiKey(self.apiKey)
        self.view.updateRefreshRate(self.refreshRate.description)
    }
    
    //
    // MARK: Projects
    //
    
    var numberOfProjects: Int {
        get { return self.allProjects.count }
    }
    
    func projectAtIndex(index: Int) -> Project {
        return self.allProjects[index];
    }
    
    func toggleEnabledStateForProjectAtIndex(index: Int) {
        let project = self.projectAtIndex(index)
        project.isEnabled = !project.isEnabled
    
        self.setNeedsRefresh()
    }

    private func refreshProjects() {
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        
        if let projects = appDelegate.projects{
            self.allProjects = projects
            
            // load hidden project ids from storage and update our models appropriately
            if let hiddenProjectIds = self.defaults.objectForKey("hiddenProjects") as? [Int] {
                for project in projects {
                    project.isEnabled = !hiddenProjectIds.contains(project.id)
                }
            }
            
            // notify the view that the projects refreshed
            self.view.updateProjects(projects)
        }
    }
    
    //
    // MARK: Accessors
    //
    
    private var defaults: NSUserDefaults {
        get { return NSUserDefaults.standardUserDefaults() }
    }
}