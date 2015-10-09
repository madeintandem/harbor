//
//  TimerCoordinator.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class TimerCoordinator : NSObject {

    //
    // MARK: Dependencies
    //
    
    var currentRunLoop:     RunLoop!
    var projectsInteractor: ProjectsInteractor!
    var settingsManager:    SettingsManager!
    
    //
    // MARK: Properties
    //
    
    private var currentTimer: NSTimer?
    
    init(
        runLoop:            RunLoop            = core().inject(),
        projectsInteractor: ProjectsInteractor = core().inject(),
        settingsManager:    SettingsManager    = core().inject()) {
            
        self.currentRunLoop     = runLoop
        self.projectsInteractor = projectsInteractor
        self.settingsManager    = settingsManager
        
        super.init()
        
        settingsManager.observeNotification(.RefreshRate) { notification in
            self.startTimer()
        }
    }
    
    //
    // MARK: Scheduling
    //
    
    func startup() {
        self.startTimer()
    }
    
    func startTimer() -> NSTimer? {
        return self.setupTimer(self.settingsManager.refreshRate)
    }
    
    private func setupTimer(refreshRate: Double) -> NSTimer? {
        // cancel current timer if necessary
        self.currentTimer?.invalidate()
        self.currentTimer = nil
        
        if !refreshRate.isZero {
            self.currentTimer = NSTimer(timeInterval: refreshRate, target: self, selector:"handleUpdateTimer:", userInfo: nil, repeats: true)
            self.currentRunLoop.addTimer(self.currentTimer!, forMode: NSDefaultRunLoopMode)
        }
        
        return self.currentTimer
    }
    
    func handleUpdateTimer(timer: NSTimer) {
        if(timer == self.currentTimer) {
            self.projectsInteractor.refreshProjects()
        }
    }
    
}