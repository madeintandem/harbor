import Foundation

class TimerCoordinator: NSObject, TimerCoordinatorType {
  //
  // MARK: Dependencies
  var settings: SettingsType!
  var runLoop:  RunLoop!
  var projectsInteractor: ProjectsInteractor!

  //
  // MARK: Properties
  private var currentTimer: NSTimer?

  init(runLoop: RunLoop, projectsInteractor: ProjectsInteractor, settings: SettingsType) {
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

  func stopTimer() {
    currentTimer?.invalidate()
    currentTimer = nil
  }

  //
  // MARK: Helpers
  private func setupTimer(refreshRate: Double) -> NSTimer? {
    // cancel current timer if necessary
    stopTimer()

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