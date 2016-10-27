import Foundation
import Cocoa

class PreferencesPresenter<V: PreferencesView> : Presenter<V> {
  //
  // MARK: Dependencies
  private var settings:           SettingsType
  private let projectsInteractor: ProjectsInteractor
  private let timerCoordinator:   TimerCoordinatorType

  //
  // MARK: Properties
  private var apiKey:           String = ""
  private var refreshRate:      Int = 60
  private(set) var launchOnLogin:    Bool   = true
  private var allProjects:      [Project]
  private var apiKeyError:      String = ""
  private var refreshRateError: String = ""

  private(set) var needsRefresh: Bool = true

  init(view: V, projectsInteractor: ProjectsInteractor, settings: SettingsType, timerCoordinator: TimerCoordinatorType) {
    self.projectsInteractor = projectsInteractor
    self.settings = settings
    self.timerCoordinator = timerCoordinator
    self.allProjects = [Project]()

    super.init(view: view)
  }
  
  required init(view: V) {
    fatalError("init(view:) has not been implemented")
  }

  //
  // MARK: Presentation Cycle
  override func didInitialize() {
    super.didInitialize()

    // TODO: rather than listen for project updates on the refresh interval, it seems like the
    // preferences presenter should just get the current list of projects and render them
    // (then it doesn't need to mess with timers at all)
    projectsInteractor.addListener(refreshProjects)
  }

  override func didBecomeActive() {
    super.didBecomeActive()

    // TODO: rather than refresh keys whenever become/resignActive is called, the presenter
    // should refresh on didInitialize
    refreshIfNecessary()
    timerCoordinator.stopTimer()
  }

  override func didResignActive() {
    super.didResignActive()
    refreshIfNecessary()
    _ = timerCoordinator.startTimer()
  }

  func setNeedsRefresh() {
    if(!needsRefresh) {
      needsRefresh = true
    }
  }

  private func refreshIfNecessary() {
    if(needsRefresh) {
      refreshConfiguration()
      needsRefresh = false
    }
  }

  //
  // MARK: Preferences
  func savePreferences() {
    // persist our configuration
    settings.apiKey = apiKey
    settings.refreshRate = refreshRate
    settings.launchOnLogin = launchOnLogin

    // serialize the hidden projects
    settings.disabledProjectIds = allProjects.reduce([Int]()) { memo, project in
      var memo = memo

      if !project.isEnabled {
        memo.append(project.id)
      }

      return memo
    }

    needsRefresh = false
  }

  func updateApiKey(_ apiKey: String) {
    self.apiKey = apiKey
    validate(apiKey: apiKey)
  }

  func updateRefreshRate(_ refreshRate: String) {
    self.refreshRate = (refreshRate as NSString).integerValue
    validate(refreshRate: refreshRate)
    setNeedsRefresh()
  }

  func updateLaunchOnLogin(_ launchOnLogin: Bool) {
    self.launchOnLogin = launchOnLogin
    setNeedsRefresh()
  }

  private func refreshConfiguration() {
    // TODO: if we only refresh on initialize (more of a sync) then we can throw out the 
    // setNeedsRefresh/refreshIfNeeded stuff completely. this method can instead call individual
    // update methods like `updateApiKey(settings.apiKey)`
    //
    // each of those methods could 
    //   1. update state
    //   2. run validations
    //   3. call the correct view method

    // load data from user defaults
    launchOnLogin = settings.launchOnLogin
    refreshRate   = settings.refreshRate
    apiKey        = settings.apiKey

    updateApiKey(apiKey)
    updateRefreshRate(refreshRate.description)

    // update our view after refreshing
    view.updateApiKey(apiKey)
    view.updateRefreshRate(refreshRate.description)
    view.updateLaunchOnLogin(launchOnLogin)
    view.updateApiKeyError(apiKeyError)
    view.updateRefreshRateError(refreshRateError)
  }

  //
  // MARK: Projects
  var numberOfProjects: Int {
    get { return allProjects.count }
  }

  func projectAtIndex(_ index: Int) -> Project {
    return allProjects[index];
  }

  func toggleEnabledStateForProjectAtIndex(_ index: Int) {
    let project = projectAtIndex(index)
    project.isEnabled = !project.isEnabled

    setNeedsRefresh()
  }

  private func refreshProjects(_ projects: [Project]) {
    allProjects = projects

    // notify the view that the projects refreshed
    view.updateProjects(allProjects)
  }

  //
  // MARK: Accessors
  private var defaults: UserDefaults {
    get { return UserDefaults.standard }
  }

  //
  // MARK: Validations
  private func validate(apiKey: String) {
    if apiKey.isEmpty {
      apiKeyError = "can't be blank"
    } else {
      apiKeyError = ""
    }

    view.updateApiKeyError(apiKeyError)
  }

  private func validate(refreshRate: String) {
    let refreshValue = Int(refreshRate)

    if refreshValue == nil {
      refreshRateError = "must be a number"
    } else if !(5 ... 600 ~= refreshValue!) {
      refreshRateError = "must be between 5 and 600 seconds"
    } else {
      refreshRateError = ""
    }

    view.updateRefreshRateError(refreshRateError)
  }
}
