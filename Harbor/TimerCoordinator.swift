import Foundation

class TimerCoordinator : NSObject {
  //
  // MARK: Dependencies
  var settings: Settings!
  var runLoop:  RunLoop!
  var projectsInteractor: ProjectsInteractor!

  //
  // MARK: Properties
  private var currentTimer: NSTimer?

  init(runLoop: RunLoop, projectsInteractor: ProjectsInteractor, settings: Settings) {
    self.runLoop  = runLoop
    self.settings = settings
    self.projectsInteractor = projectsInteractor

    super.init()

    settings.observeNotification(.RefreshRate) { notification in
      self.startTimer()
    }
  }

  //
  // MARK: Scheduling
  func startup() {
    startTimer()
  }

  func startTimer() -> NSTimer? {
    return setupTimer(settings.refreshRate)
  }

  //
  // MARK: Helpers
  private func setupTimer(refreshRate: Double) -> NSTimer? {
    // cancel current timer if necessary
    currentTimer?.invalidate()
    currentTimer = nil

    if !refreshRate.isZero {
      currentTimer = NSTimer(timeInterval: refreshRate, target: self, selector:#selector(TimerCoordinator.handleUpdateTimer(_:)), userInfo: nil, repeats: true)
      runLoop.addTimer(currentTimer!, forMode: NSDefaultRunLoopMode)
    }

    return currentTimer
  }

  func handleUpdateTimer(timer: NSTimer) {
    if(timer == currentTimer) {
      projectsInteractor.refreshProjects()
    }
  }
}