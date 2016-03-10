//
//  PreferencesPaneWindowController.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/8/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate, NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate, PreferencesView {
    
    enum ColumnIdentifier: String {
        case ShowProject    = "ShowProject"
        case RepositoryName = "RepositoryName"
    }
    
    //
    // MARK: Properties
    //
    
    var presenter: PreferencesPresenter<PreferencesPaneWindowController>!

    @IBOutlet weak var codeshipAPIKey: TextField!
    @IBOutlet weak var refreshRateTextField: TextField!
    @IBOutlet weak var projectTableView: NSTableView!
    @IBOutlet weak var launchOnLoginCheckbox: NSButton!
        
    override init(window: NSWindow?) {
        super.init(window: window)
        
        self.presenter = PreferencesPresenter(view: self)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        self.presenter.didInitialize()
    }
    
    func windowDidChangeOcclusionState(notification: NSNotification) {
        let window = notification.object!
        
        if window.occlusionState.contains(NSWindowOcclusionState.Visible) {
            self.presenter.didBecomeActive()
        } else {
            self.presenter.didResignActive()
        }
    }
    
    //
    // MARK: PreferencesView
    //
    
    func updateProjects(projects: [Project]) {
        self.projectTableView.reloadData()
    }
    
    func updateApiKey(apiKey: String) {
        self.codeshipAPIKey.stringValue = apiKey
    }
    
    func updateRefreshRate(refreshRate: String) {
        self.refreshRateTextField.stringValue = refreshRate
    }
    
    func updateLaunchOnLogin(launchOnLogin: Bool) {
        self.launchOnLoginCheckbox.enabled = launchOnLogin
    }
    
    //
    // MARK: Interface Actions
    //
   
    @IBAction func launchOnLoginCheckboxClicked(sender: AnyObject) {
        self.presenter.updateLaunchOnLogin(self.launchOnLoginCheckbox.enabled)
    }
   
    @IBAction func isEnabledCheckboxClicked(sender: AnyObject) {
        let button = sender as? NSButton
        
        if let view = button?.nextKeyView as? NSTableCellView {
            let row = self.projectTableView.rowForView(view)
            self.presenter.toggleEnabledStateForProjectAtIndex(row)
        }
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        self.presenter.savePreferences()
        self.close()
    }
    
    //
    // MARK: NSTextFieldDelegate
    //
    
    override func controlTextDidChange(obj: NSNotification) {
        if let textField = obj.object as? TextField {
            if textField == self.codeshipAPIKey {
                self.presenter.updateApiKey(textField.stringValue)
            } else if textField == self.refreshRateTextField {
                self.presenter.updateRefreshRate(textField.stringValue)
            }
        }
    }
    
    //
    // MARK: NSTableViewDataSource
    //
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.presenter.numberOfProjects
    }
    
    //
    // MARK: NSTableViewDelegate
    //
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSView? = nil
        
        if let tableColumn = tableColumn {
            let project  = self.presenter.projectAtIndex(row)
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

}
