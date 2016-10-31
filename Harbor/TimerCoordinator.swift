import Foundation

class TimerCoordinator: NSObject, TimerCoordinatorType {
  //
  // MARK: Dependencies
  var settings: SettingsType!
  var scheduler: Scheduler!
  var projectsInteractor: ProjectsInteractor!

  //
  // MARK: Properties
  private var currentTimer: Timer?

  init(scheduler: Scheduler, projectsInteractor: ProjectsInteractor, settings: SettingsType) {
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

  func startTimer() {
    return setupTimer(refreshRate: settings.refreshRate)
  }

  func stopTimer() {
    currentTimer?.invalidate()
    currentTimer = nil
  }

  //
  // MARK: Helpers
  private func setupTimer(refreshRate: Int) {
    // cancel current timer if necessary
    stopTimer()

    if refreshRate != 0 {
      currentTimer = Timer(timeInterval: Double(refreshRate), target: self, selector:#selector(TimerCoordinator.handleUpdateTimer), userInfo: nil, repeats: true)
      scheduler.addTimer(timer: currentTimer!, forMode: .defaultRunLoopMode)
    }
  }

  func handleUpdateTimer(timer: Timer) {
    if(timer == currentTimer) {
      projectsInteractor.refreshProjects()
    }
  }
}
