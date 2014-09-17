//
//  StatusView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//
import Cocoa

class StatusView: NSView, NSMenuDelegate, NSPopoverDelegate {
    
    let imageView:  NSImageView
    let statusBar:  NSStatusBar
    var statusItem: NSStatusItem
    var popover:    NSPopover?
    var managedObjectContext: NSManagedObjectContext?
    var active:     Bool
    var statusItemMenu: NSMenu

    var transiencyMonitor: AnyObject? = nil
    
    //so - you have to instantiate all the properties of the class before calling super.  
    // you can then use the awake from nib like a viewDidLoad to call things on self. 
 
    required init(coder aDecoder: (NSCoder!)) {
        
        active = false

        statusBar =  NSStatusBar.systemStatusBar()
        imageView = NSImageView(frame: NSMakeRect(0, 0, statusBar.thickness, statusBar.thickness))
        statusItem = statusBar.statusItemWithLength(statusBar.thickness)
        statusItem.image = NSImage(named: "codeshipLogo_black")
        
        statusItemMenu = NSMenu()
        statusItem.menu = statusItemMenu
        
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
        statusItem.menu = statusItemMenu

        super.init(frame: imageView.frame)
        
        self.addSubview(imageView)
        statusItem.view = self
        self.setupMenu()
    }

    
    // MARK: View Life Cycle
    
    func setupMenu(){
        statusItemMenu.delegate = self
        statusItemMenu.autoenablesItems = false
        statusItem.menu = statusItemMenu
        self.updateUI()
    }

    
    func setActive(isActive: Bool)
    {
        active = isActive;
        self.updateUI()
    }

    func updateUI()
    {
        imageView.image = NSImage(named: "codeshipLogo_black")
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
    
    override func mouseDown(theEvent: NSEvent!)
    {
        if(active){
            self.hidePopover()
            
        } else {
            var popoverViewController = PopoverViewController()
            popoverViewController.managedObjectContext = self.managedObjectContext

            self.showPopoverWithViewController(popoverViewController)
            
            if (transiencyMonitor == nil) {
                transiencyMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.LeftMouseDownMask, handler: handlerEvent)
                transiencyMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.RightMouseDownMask, handler: handlerEvent)
                transiencyMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask, handler: handlerEvent)
                
            }
        }
    }

    func handlerEvent(aEvent: (NSEvent!)) -> Void {
        NSEvent.removeMonitor(transiencyMonitor)
        transiencyMonitor = nil
        self.hidePopover()
        
    }
    
    func showPopoverWithViewController(viewController: NSViewController){
    
        if(popover == nil){
            popover = NSPopover()
            popover?.behavior = NSPopoverBehavior.Semitransient
            popover!.contentViewController = viewController
        }
        
        if(!popover!.shown){
            popover!.showRelativeToRect(self.frame, ofView: self, preferredEdge: 1)
            self.setActive(true)

        }
    }

    func hidePopover() {
        if (popover? != nil && popover!.shown){
            popover!.close()
            self.setActive(false)

        }
    }

    func quitMenuItemAction(sender: AnyObject)
    {
        NSApplication.sharedApplication().terminate(self)
    }
    
}
