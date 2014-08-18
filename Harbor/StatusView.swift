//
//  StatusView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//
import Foundation
import Cocoa

class StatusView: NSView, NSMenuDelegate {
    
    let imageView:  NSImageView
    let statusBar:  NSStatusBar
    var statusItem: NSStatusItem
    var popover:    NSPopover?
    var active:     Bool
    var statusItemMenu: NSMenu
    
    //so - you have to instantiate all the properties of the class before calling super.  
    // you can then use the awake from nib like a viewDidLoad to call things on self. 
 
    required init(coder aDecoder: NSCoder!) {
        
        active = false

        statusBar =  NSStatusBar.systemStatusBar()
        imageView = NSImageView(frame: NSMakeRect(0, 0, statusBar.thickness, statusBar.thickness))
        statusItem = statusBar.statusItemWithLength(statusBar.thickness)
        statusItem.image = NSImage(named: "codeshipLogo_black")
        
        statusItemMenu = NSMenu()
        
        super.init(coder: aDecoder)
        
        self.addSubview(imageView)
        statusItem.view = self
        self.setupMenu()

    }
    
    override init() {
        active = false
        
        statusBar =  NSStatusBar.systemStatusBar()
        imageView = NSImageView(frame: NSMakeRect(0, 0, statusBar.thickness, statusBar.thickness))
        statusItem = statusBar.statusItemWithLength(statusBar.thickness)
        statusItem.image = NSImage(named: "codeshipLogo_black")
        
        statusItemMenu = NSMenu()
        
        super.init(frame: imageView.frame)
        
        self.addSubview(imageView)
        statusItem.view = self
        self.setupMenu()
    }

    
    // MARK: View Life Cycle
    
    func setupMenu(){
        statusItemMenu.delegate = self
        statusItemMenu.autoenablesItems = false
        statusItemMenu.addItemWithTitle("Menu Item 1", action: "logSomething", keyEquivalent: "")
        
        statusItemMenu.addItem(NSMenuItem.separatorItem())
        var quitItem: NSMenuItem = NSMenuItem(title: "Quit", action: "quitMenuItemAction", keyEquivalent: "Q")
        quitItem.target = self
        quitItem.enabled = true
        statusItemMenu.addItem(quitItem)
        
        statusItem.menu = statusItemMenu
        self.updateUI()
    }
    
    func logSomething(){
        println("you tapped a menu item")
    }
    
    
    func setActive(isActive: Bool)
    {
        active = isActive;
        self.updateUI()
    }

    func updateUI()
    {
        imageView.image = NSImage(named: "codeshipLogo_black")
        
        //        [self setNeedsDisplay:YES];
        
    }
    
    override func drawRect(dirtyRect: NSRect) {
        if(active){
            NSColor.selectedMenuItemColor().setFill()
            NSRectFill(dirtyRect)
        } else {
            NSColor.clearColor().setFill()
            NSRectFill(dirtyRect)
        }
    }
        

    // MARK: Actions
    override func mouseDown(theEvent: NSEvent!)
    {
        if(active){
            self.hidePopover()
        } else {
            self.showPopoverWithViewController(Popover())
        }
    }

    override func mouseUp(theEvent: NSEvent!) {
        println("not sure what to do on mouseUp yet.")
    }
    
    func showPopoverWithViewController(viewController: NSViewController){
    
        if(popover == nil){
            popover = NSPopover()
            popover!.contentViewController = viewController
        }
        
        if(!popover!.shown){
            popover!.showRelativeToRect(self.frame, ofView: self, preferredEdge: 1)
            self.setActive(true)

        }
    }

    func hidePopover() {
        if (popover! != nil && popover!.shown){
            popover!.close()
            self.setActive(false)

        }
    }

    func quitMenuItemAction(sender: AnyObject)
    {
        NSApplication.sharedApplication().terminate(self)
    }
    
    // MARK: NSMenu Delegate
    
    func menuDidClose(menu: NSMenu!) {
        self.setActive(false)
    }
}
