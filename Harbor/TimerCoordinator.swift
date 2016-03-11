import Foundation

class TimerCoordinator : NSObject {
  //
  // MARK: Dependencies
  var currentRunLoop:     RunLoop!
  var projectsInteractor: ProjectsInteractor!
  var settingsManager:    SettingsManager!

  //
  // MARK: Properties
  private var currentTimer: NSTimer?

  init(runLoop: RunLoop, projectsInteractor: ProjectsInteractor, settings: SettingsManager) {
    self.currentRunLoop     = runLoop
    self.projectsInteractor = projectsInteractor
    self.settingsManager    = settings

    super.init()

    settingsManager.observeNotification(.RefreshRate) { notification in
      self.startTimer()
    }
  }

  //
  // MARK: Scheduling
  func startup() {
    startTimer()
  }

  func startTimer() -> NSTimer? {
    return setupTimer(settingsManager.refreshRate)
  }

  //
  // MARK: Helpers
  private func setupTimer(refreshRate: Double) -> NSTimer? {
    // cancel current timer if necessary
    currentTimer?.invalidate()
    currentTimer = nil

    if !refreshRate.isZero {
      currentTimer = NSTimer(timeInterval: refreshRate, target: self, selector:"handleUpdateTimer:", userInfo: nil, repeats: true)
      currentRunLoop.addTimer(currentTimer!, forMode: NSDefaultRunLoopMode)
    }

    return currentTimer
  }

  func handleUpdateTimer(timer: NSTimer) {
    if(timer == currentTimer) {
      projectsInteractor.refreshProjects()
    }
  }
}