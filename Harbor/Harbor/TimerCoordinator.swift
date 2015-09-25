//
//  TimerCoordinator.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class TimerCoordinator : NSObject {

    static let instance = TimerCoordinator()
    
    //
    // MARK: Dependencies
    //
    
    let projectsStore =     ProjectsProvider.instance
    let currentRunLoop =    NSRunLoop.currentRunLoop()
    
    //
    // MARK: Properties
    //
    
    var currentTimer: NSTimer?
    
    //
    // MARK: Scheduling
    //
    
    func setupTimer(refreshRate: Double) {
        // cancel current time if necessary
        self.currentTimer?.invalidate()
        if !refreshRate.isZero {
            self.currentTimer = NSTimer(timeInterval: refreshRate, target: self, selector:"handleUpdateTimer:", userInfo: nil, repeats: true)
            self.currentRunLoop.addTimer(self.currentTimer!, forMode: NSDefaultRunLoopMode)
        }
    }
    
    func handleUpdateTimer(timer: NSTimer) {
        if(timer == self.currentTimer) {
            self.projectsStore.refreshProjects()
            print("updating projects")
        }
    }
    
}