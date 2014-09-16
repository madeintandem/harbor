//
//  Popover.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate, NSControlTextEditingDelegate{

    var projectList: [Project]?
    var managedObjectContext: NSManagedObjectContext?
    var apiKey: NSString?
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var preferencesButton: NSButton!
    
    
    @IBAction func preferencesButton(sender: AnyObject) {
        
        let appDelegate = (NSApplication.sharedApplication()?.delegate as AppDelegate)
        var window = appDelegate.preferencesPaneWindow?.window

        // Set position of the window and display it
        window?.makeKeyAndOrderFront(self)
        
        // Show your window in front of all other apps
        NSApp.activateIgnoringOtherApps(true)
        
        appDelegate.hidePopover(self)
    }

    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
 
    override init() {
        super.init(nibName: "Popover", bundle: nil)
    }
    
    // MARK: View Lifecycle

    
    override func loadView() {
        
        super.loadView()
        projectList = []
        apiKey = "b02bb166df85e6369d81824a8e32a0535e677299a381ec3877b4871a8285"
        self.retrieveProjectsForKey(apiKey!)
    }
    
    
    func retrieveProjectsForKey(key: String){
        var urlWithKey = "https://www.codeship.io/api/v1/projects.json?api_key=" + apiKey!
        println(urlWithKey)
        var urlRequest: NSURLRequest = NSURLRequest(URL: NSURL(string:urlWithKey));
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (urlResponse, data, error) -> Void in
            var responseDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as NSDictionary
                        var projectsArray: Array<AnyObject> = responseDictionary.objectForKey("projects") as Array
            
            for hash in projectsArray {
                var project = Project()
                project.id = Int(hash.objectForKey("id") as NSNumber)
                project.repositoryName = (hash.objectForKey("repository_name") as String)
                var projectBuildJson: Array<AnyObject> = hash.objectForKey("builds") as Array<AnyObject>
                var projectBuilds: [Build] = []
                
                for buildHash in projectBuildJson {
                    
                    var build = Build()
                    build.id =  Int(buildHash.objectForKey("id") as NSNumber)
                    build.uuid =  (buildHash.objectForKey("uuid") as String)
                    build.status =  (buildHash.objectForKey("status") as String)
                    build.commitId =  (buildHash.objectForKey("commit_id") as String)
                    build.message =  (buildHash.objectForKey("message") as String)
                    build.branch =  (buildHash.objectForKey("branch") as String)
                    
                    project.builds.append(build)
                }
                
                self.projectList!.append(project)
                self.tableView.reloadData()
            }
        }
    }
        // MARK: NSTableViewDelegate
   
    func numberOfRowsInTableView(NSTableView) -> Int {
        if (projectList == nil) { return 0 }
        
        return projectList!.isEmpty ? 1 : projectList!.count
    }
    
    func tableView(aTableView: NSTableView!,
        objectValueForTableColumn aTableColumn: NSTableColumn!,
        row rowIndex: Int) -> AnyObject! {
            
            if !projectList!.isEmpty {
            var project: Project = projectList![rowIndex]
            if aTableColumn.identifier == "AutomaticTableColumnIdentifier.0" {
                
                var statusImage: NSImage
                
                if project.builds.first?.status == "success"
                {
                    statusImage = NSImage(named: "codeshipLogo_green")
                } else {
                    statusImage = NSImage(named: "codeshipLogo_red")
                }
                
                return statusImage
            }
            if aTableColumn.identifier == "AutomaticTableColumnIdentifier.1" {
                var projectBuildSummary: String
                var recentBuild: Build = project.builds.first!
                projectBuildSummary = project.repositoryName! + "\n" + recentBuild.message!
                
                return projectBuildSummary
            }
                return project} else {
                return nil
            }
    }
    

    // Only allow rows to be selectable if there are items in the list.
    func tableView(NSTableView, shouldSelectRow: Int) -> Bool {
        return !projectList!.isEmpty
    }
}