//
//  Popover.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSControlTextEditingDelegate{

    
    dynamic var projectList: [Project]?
    dynamic var managedObjectContext: NSManagedObjectContext?
    let appDelegate: AppDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
    
    @IBAction func quitButton(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(self)
    }
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var preferencesButton: NSButton!
    @IBOutlet weak var titleLabel: NSTextField!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init?(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: "Popover", bundle: nil)
        
    }
    
    // MARK: View Lifecycle

    
    override func loadView() {
        super.loadView()
        projectList = []

        let bariolBold16: NSFont = NSFont (name: "Bariol-Bold", size: 16)!
        self.titleLabel.font = bariolBold16
    }
    
    override func viewDidAppear() {
        self.refreshTableView()
        print("projectlist count at reload data \(projectList!.count)")
    }
    
    func refreshTableView() {
        appDelegate.fetchApiKeys { (projects) -> () in
            self.projectList = projects
            self.tableView.reloadData()
        }
    }
    
    // MARK: NSTableViewDelegate
   
    
    func numberOfRowsInTableView(NSTableView) -> Int {
        
        return projectList!.isEmpty ? 1 : projectList!.count
    }

    func tableView(aTableView: NSTableView!,
        objectValueForTableColumn aTableColumn: NSTableColumn!,
        
        row rowIndex: Int) -> AnyObject! {
            
            if !projectList!.isEmpty {
            let project: Project = projectList![rowIndex]
            let recentBuild: Build = project.builds.first!
                
                if aTableColumn.identifier == "statusImageColumn" {
                
                    var statusImage: NSImage
                    
                    if project.builds.first?.status == "success"{
                        statusImage = NSImage(named: "codeshipLogo_green")!
                        
                    } else if project.builds.first?.status == "testing" {
                        statusImage = NSImage(named: "codeshipLogo_black")!
                        
                    } else {
                        statusImage = NSImage(named: "codeshipLogo_red")!
                    }
                    
                    return statusImage
                    
                } else if aTableColumn.identifier == "buildInfoColumn" {
                    
                    let bariolBold: NSFont = NSFont (name: "Bariol-Bold", size: 13)!
                    let repoAttrs = [NSFontAttributeName : bariolBold]
                    let projectBuildSummary =  NSMutableAttributedString(string:
                        "\(project.repositoryName!.capitalizedString)\n", attributes: repoAttrs)

                    let bariolLight: NSFont = NSFont (name: "Bariol-Light", size: 11)!
                    let commitAttrs = [NSFontAttributeName : bariolLight]
                  let buildMessage = NSMutableAttributedString(string: "\(recentBuild.message!)", attributes: commitAttrs)

                    projectBuildSummary.appendAttributedString(buildMessage)
                    return projectBuildSummary
                    
                } else {
                    return nil
                }
            } else {
                return nil
            }
            
    }
    

    // Only allow rows to be selectable if there are items in the list.
    func tableView(NSTableView, shouldSelectRow: Int) -> Bool {
        return !projectList!.isEmpty
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        let index = tableView.selectedRow

        if index >= 0 {
            let selectedProject: Project = projectList![tableView.selectedRow]
            let recentBuild: Build = selectedProject.builds.first!

            let buildLinkString = "https://codeship.com/projects/\(selectedProject.id!)/builds/\(recentBuild.id!)"
            let buildURL: NSURL = NSURL(string: buildLinkString)!
            let workspace = NSWorkspace.sharedWorkspace()

            workspace.openURL(buildURL)
            tableView.deselectRow(index)
            appDelegate.hidePopover(self)
        }
    }


    @IBAction func preferencesButton(sender: AnyObject) {
        
        let window = appDelegate.preferencesPaneWindow?.window
        appDelegate.hidePopover(self)
        
        // Set position of the window and display it
        window?.makeKeyAndOrderFront(self)
        window?.center()
        
        // Show your window in front of all other apps
        NSApp.activateIgnoringOtherApps(true)
        
    }
}