
//  StatusMenu.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/4/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

protocol StatusMenuDelegate: NSMenuDelegate {
    func statusMenuDidSelectPreferences(statusMenu: StatusMenu)
}

class StatusMenu: NSMenu, StatusMenuView {
 
    //
    // MARK: Dependencies
    //
    
    private var presenter: StatusMenuPresenter<StatusMenu>!
   
    //
    // MARK: Properties
    //
    
    private let fixedMenuItemCount = 3
    private let statusBarItem      = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // NSVariableStatusItemLength

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.presenter = StatusMenuPresenter(view: self)
        self.presenter.didInitialize()
    }
    
    //
    // MARK: StatusMenuView
    //
    
    func createCoreMenuItems() {
        self.statusBarItem.menu = self
        
        let preferences    = self.itemAtIndex(1)!
        preferences.target = self
        preferences.action = Selector("didClickPreferencesItem")
    }
    
    func updateBuildStatus(status: BuildStatus) {
        self.statusBarItem.image = status.icon()
    }
   
    func updateProjects(projects: [Project]) {
        // clear stale projects, if any, from menu
        let range = self.fixedMenuItemCount..<self.itemArray.count
        for index in range.reverse() {
            self.removeItemAtIndex(index)
        }

        // add the separator between fixed items and projects
        let separatorItem = NSMenuItem.separatorItem()
        self.addItem(separatorItem)
       
        // add each project
        for project in projects {
            self.createProjectMenuItem(project)
        }
    }

    func createProjectMenuItem(project: Project){
        let projectMenuItem = NSMenuItem(title: project.repositoryName, action: nil, keyEquivalent: "")
        
        //set icon color
        if let firstBuild = project.builds.first {
            if firstBuild.status == "success"{
                projectMenuItem.image = NSImage(named: "codeshipLogo_green")!
                projectMenuItem.image?.template = false
            } else if firstBuild.status == "error"{
                projectMenuItem.image = NSImage(named: "codeshipLogo_red")!
                projectMenuItem.image?.template = false
            } else {
                projectMenuItem.image = NSImage(named: "codeshipLogo_black")
                projectMenuItem.image?.template = true //works with light & dark menubars
            }
        } else {
            projectMenuItem.image = NSImage(named: "codeshipLogo_black")
            projectMenuItem.image?.template = true //works with light & dark menubars
            
        }
        
        let buildMenu = NSMenu(title: "Builds")
        projectMenuItem.submenu = buildMenu
        
        for build in project.builds{
            self.createSubmenuItem(build, buildMenu: buildMenu, projectID: project.id)
        }
        
        self.addItem(projectMenuItem)
    }
    
    func createSubmenuItem(aBuild: Build, buildMenu: NSMenu, projectID: Int){
        aBuild.codeshipLinkString = "https://codeship.com/projects/\(projectID)/builds/\(aBuild.id!)"
        
        let buildMenuItem = NSMenuItem(title: aBuild.message!, action: "openBuildLink:", keyEquivalent: "")
        buildMenuItem.representedObject = aBuild
        
        buildMenuItem.view = self.createBuildView(aBuild)
        buildMenuItem.target = self
        buildMenu.addItem(buildMenuItem)
    }
    
    func createBuildView(aBuild: Build) -> NSView {
        let buildView = BuildView(frame: NSRect(x: 0, y: 0, width: 300, height: 53))
        
        var buildMessageLabel : String
        if let message = aBuild.message {
            buildMessageLabel = message
        } else {
            buildMessageLabel = "Unknown"
        }
        
        var startDateString : String
        if let date = aBuild.startedAt {
            startDateString = self.makeReadableStringForDate(date)
        } else {
            startDateString = "Unknown Date"
        }
        
        var usernameLabel : String
        if let name = aBuild.gitHubUsername {
            usernameLabel = "By \(name) at \(startDateString)"
        } else {
            usernameLabel = "Started at: \(startDateString)"
        }
        
        buildView.buildMessageLabel.stringValue = buildMessageLabel
        buildView.dateAndUsernameLabel.stringValue = usernameLabel
        
        return buildView
    }
    
    func makeReadableStringForDate(aDate: NSDate) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY 'at' hh:mm a"

        return dateFormatter.stringFromDate(aDate)
    }
    
    func openBuildLink(sender: NSMenuItem){
        let build = sender.representedObject as! Build
        let buildURL: NSURL = NSURL(string: build.codeshipLinkString!)!
        let workspace = NSWorkspace.sharedWorkspace()
        
        workspace.openURL(buildURL)
    }
    
    //
    // MARK: Interface Actions
    //
    
    func didClickPreferencesItem() {
        self.statusMenuDelegate.statusMenuDidSelectPreferences(self)
    }
    
    //
    // MARK: Custom Delegate
    //
   
    var statusMenuDelegate: StatusMenuDelegate {
        get { return self.delegate as! StatusMenuDelegate }
        set { self.delegate = newValue }
    }
}

private extension BuildStatus {
   
    func icon() -> NSImage {
        let image = NSImage(named: self.rawValue)!
        // allows black icon to work with light & dark menubars
        image.template = self == .Unknown
        
        return image
    }
    
}
