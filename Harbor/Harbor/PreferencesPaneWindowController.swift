//
//  PreferencesPaneWindowController.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/8/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate, NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate {
    
    enum ColumnIdentifier: String {
        case ShowProject    = "ShowProject"
        case RepositoryName = "RepositoryName"
    }

    @IBOutlet weak var codeshipAPIKey: NSTextField!
    @IBOutlet weak var refreshRateTextField: NSTextField!
    @IBOutlet weak var projectTableView: NSTableView!
    
    var allProjects: [Project]
    var hiddenProjects: [Int]
    var defaults: NSUserDefaults
    
    override init(window: NSWindow?) {
        allProjects = []
        defaults = NSUserDefaults()
        if let defaultHiddenProjects = defaults.valueForKey("hiddenProjects"){
            hiddenProjects = defaultHiddenProjects as! [Int]
        } else {
            hiddenProjects = []
        }
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        KeychainWrapper.setString(codeshipAPIKey.stringValue, forKey: "APIKey")
        CodeshipApi.getProjects(handleGetProjectsRequest, errorHandler: handleGetProjectsError)
        self.close()
    }

    func handleGetProjectsRequest(result: [Project]){
        (NSApplication.sharedApplication().delegate as! AppDelegate).handleGetProjectsRequest(result)
    }
    
    func handleGetProjectsError(error: String){
        //this is only a JSON Parsing error.  A fetch error needs separate handling.
        debugPrint(error)
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        let appDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
        allProjects = appDelegate.projects!
        self.projectTableView.reloadData()
        
        if let token = KeychainWrapper.stringForKey("APIKey"){
            codeshipAPIKey.stringValue = token as String
        }
        
        if let refreshRate = KeychainWrapper.stringForKey("refreshRate"){
            refreshRateTextField.stringValue = refreshRate
        }
        
    }
    
    //
    // MARK: NSTableViewDataSource
    //
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return allProjects.count
    }
    
    //
    // MARK: NSTableViewDelegate
    //
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSView? = nil
        
        if let tableColumn = tableColumn {
            let project  = allProjects[row]
            project.isEnabled = !hiddenProjects.contains(project.id)
            let cellView = tableView.makeViewWithIdentifier(tableColumn.identifier, owner: self) as! NSTableCellView
            
            switch ColumnIdentifier(rawValue: tableColumn.identifier)! {
                case .ShowProject:
                    cellView.objectValue = project.isEnabled ? NSOnState : NSOffState
                case .RepositoryName:
                    cellView.textField!.stringValue = project.repositoryName
            }
            
            view = cellView
        }
        
        return view
    }

    @IBAction func isEnabledCheckboxClicked(sender: AnyObject) {
        let button = sender as? NSButton
        
        if let view = button?.nextKeyView as? NSTableCellView {
            let row     = self.projectTableView.rowForView(view)
            let project = allProjects[row]
            

            if button?.state == NSOnState {

                if let projectIndex = hiddenProjects.indexOf(project.id) {
                    hiddenProjects.removeAtIndex(projectIndex)
                }
                
                project.isEnabled = true
                

            } else {

                hiddenProjects.append(project.id)
                project.isEnabled = false
            }
            defaults.setObject(hiddenProjects, forKey: "hiddenProjects")
        }
    }
    
}
