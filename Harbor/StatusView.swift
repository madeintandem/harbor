//
//  StatusView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//
import Cocoa

class StatusView: NSView, NSMenuDelegate, NSPopoverDelegate {
    
    var active:     Bool
    var hasFailedBuild: Bool?
    var hasPendingBuild: Bool?
    
    let appDelegate: AppDelegate = (NSApplication.sharedApplication().delegate as! AppDelegate)
    var managedObjectContext: NSManagedObjectContext?
    
    var imageView:  NSImageView
    var popover:    NSPopover?
    var popoverViewController = PopoverViewController(nibName: "Popover", bundle: nil)
    let statusBar:  NSStatusBar
    var statusItem: NSStatusItem
    var statusItemMenu: NSMenu
    

 
    required init(coder aDecoder: (NSCoder!)) {
        active = false
        hasFailedBuild? = false
        
        statusBar =  NSStatusBar.systemStatusBar()
        imageView = NSImageView(frame: NSMakeRect(0, 0, statusBar.thickness, statusBar.thickness))
        statusItem = statusBar.statusItemWithLength(statusBar.thickness)
        statusItem.image = NSImage(named: "codeshipLogo_black")
        
        statusItemMenu = NSMenu()
        statusItem.menu = statusItemMenu
        
        self.addSubview(imageView)
        statusItem.view = self
        self.managedObjectContext = appDelegate.managedObjectContext!
        self.setupMenu()
        
    }
    
      convenience init() {
        active = false
        hasFailedBuild? = false
        hasPendingBuild? = false
        
        statusBar =  NSStatusBar.systemStatusBar()
        imageView = NSImageView(frame: NSMakeRect(0, 0, statusBar.thickness, statusBar.thickness))
        statusItem = statusBar.statusItemWithLength(statusBar.thickness)
        statusItem.image = NSImage(named: "codeshipLogo_black")
        
        statusItemMenu = NSMenu()
        statusItem.menu = statusItemMenu

        self.init(frame: imageView.frame)
        
        self.addSubview(imageView)
        statusItem.view = self
        self.managedObjectContext = appDelegate.managedObjectContext!
        self.setupMenu()

    }
    
    // MARK: View Life Cycle
    
    func setupMenu(){
        statusItemMenu.delegate = self
        statusItemMenu.autoenablesItems = false
        statusItem.menu = statusItemMenu
        self.updateUI()
    }

    
    func setIsActive(isActive: Bool)
    {
        active = isActive;
        self.updateUI()
    }

    func updateUI()
    {
        if self.hasPendingBuild == true {
            self.imageView.image = NSImage(named: "codeshipLogo_black")
            //add rotation

        } else if self.hasFailedBuild == true {
            self.imageView.image = NSImage(named: "codeshipLogo_red")
            
        } else {
            imageView.image = NSImage(named: "codeshipLogo_green")
        }
        
    
        self.setNeedsDisplayInRect(self.frame)
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
    
    override func mouseDown(theEvent: NSEvent)
    {
        if(active){
            self.hidePopover()
            
        } else {
            popoverViewController?.managedObjectContext = self.managedObjectContext
            self.showPopoverWithViewController(popoverViewController!)
        }
    }

    func showPopoverWithViewController(viewController: NSViewController){
    
        if(popover == nil){
            popover = NSPopover()
            popover?.behavior = NSPopoverBehavior.Semitransient
            popover!.contentViewController = viewController
        }
        
        if(!popover!.shown){
            popover!.showRelativeToRect(self.frame, ofView: self, preferredEdge: 1)
            self.setIsActive(true)

        }

    }

    func hidePopover() {
        if (popover != nil && popover!.shown){
            popover!.close()
            self.setIsActive(false)

        }
    }

    func quitMenuItemAction(sender: AnyObject){
        NSApplication.sharedApplication().terminate(self)
    }
    
}
