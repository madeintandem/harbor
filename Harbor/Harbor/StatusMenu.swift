//
//  StatusMenu.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/4/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class StatusMenu: NSMenu {
    let statusBarItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // NSVariableStatusItemLength
    var projects : [Project]?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(projects : [Project]) {
        self.projects = projects
        
        //create statusbar icon
        var icon = NSImage(named: "codeshipLogo_black")!
        icon.template = true //works with light & dark menubars
        
        //set icon color
        let failingProjects = projects.filter({ $0.status == 1 })
        if failingProjects.count == 0 {
            icon = NSImage(named: "codeshipLogo_green")!
            icon.template = false
            
        } else {
            icon = NSImage(named: "codeshipLogo_red")!
            icon.template = false
        }
        
        statusBarItem.image = icon

        super.init(title: "Projects")

        statusBarItem.menu = self
        
        let separatorItem = NSMenuItem.separatorItem()
        self.addItem(separatorItem)
        
        for project in (projects) {
            self.createProjectMenuItem(project)
        }

    }


    func createProjectMenuItem(project: Project){
        let projectMenuItem = NSMenuItem(title: project.repositoryName, action: nil, keyEquivalent: "")
        
        //set icon color
        if project.builds.first!.status == "success"{
            projectMenuItem.image = NSImage(named: "codeshipLogo_green")!
            projectMenuItem.image?.template = false
        } else if project.builds.first!.status == "error"{
            projectMenuItem.image = NSImage(named: "codeshipLogo_red")!
            projectMenuItem.image?.template = false
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
}
