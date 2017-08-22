import Foundation

class TimerCoordinator: NSObject, TimerCoordinatorType {
  static let instance = TimerCoordinator(
    scheduler: Foundation.RunLoop.current,
    projectsInteractor: ProjectsProvider.instance,
    settings: Settings.instance
  )

  //
  // MARK: Dependencies
  var settings: SettingsType!
  var scheduler: RunLoop!
  var projectsInteractor: ProjectsInteractor!

  //
  // MARK: Properties
  fileprivate var currentTimer: Timer?

  init(scheduler: RunLoop, projectsInteractor: ProjectsInteractor, settings: SettingsType) {
    self.scheduler = scheduler
    self.settings = settings
    self.projectsInteractor = projectsInteractor

    super.init()

    _ = settings.observeNotification(.RefreshRate) { notification in
      self.startTimer()
    }
  }

  //
  // MARK: Scheduling
  func startup() {
    startTimer()
  }

  func startTimer() -> Timer? {
    return setupTimer(settings.refreshRate)
  }

  func stopTimer() {
    currentTimer?.invalidate()
    currentTimer = nil
  }

  //
  // MARK: Helpers
  fileprivate func setupTimer(_ refreshRate: Int) -> Timer? {
    // cancel current timer if necessary
    stopTimer()

    if refreshRate != 0 {
      currentTimer = Timer(timeInterval: convertIntToDouble(refreshRate), target: self, selector:#selector(TimerCoordinator.handleUpdateTimer(_:)), userInfo: nil, repeats: true)
      scheduler.add(currentTimer!, forMode: RunLoopMode.defaultRunLoopMode)
    }

    return currentTimer
  }

  func handleUpdateTimer(_ timer: Timer) {
    if(timer == currentTimer) {
      projectsInteractor.refreshProjects()
    }
  }
  
  fileprivate func convertIntToDouble(_ integer: Int) -> Double {
    return Double(integer)
  }
}
