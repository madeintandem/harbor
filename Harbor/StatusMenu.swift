
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
   
    func updateProjects(projects: [ProjectMenuItemModel]) {
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
            self.addItem(ProjectMenuItem(model: project))
        }
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
