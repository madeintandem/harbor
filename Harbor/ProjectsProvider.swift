import Foundation

typealias ProjectHandler = ([Project] -> Void)

protocol ProjectsInteractor {
  func refreshProjects()
  func refreshCurrentProjects()
  func addListener(listener: ProjectHandler)
}

class ProjectsProvider : ProjectsInteractor {
  //
  // MARK: dependencies
  //
  private let settingsManager: SettingsManager
  private let codeshipApi: CodeshipApiType

  //
  // MARK: properties
  //
  private var projects:  [Project]
  private var listeners: [ProjectHandler]

  init(api: CodeshipApiType, settings: SettingsManager) {
    self.projects    = [Project]()
    self.listeners   = [ProjectHandler]()
    self.codeshipApi = api
    self.settingsManager = settings

    settingsManager.observeNotification(.ApiKey) { _ in
      self.refreshProjects()
    }

    settingsManager.observeNotification(.DisabledProjects) { _ in
      self.refreshCurrentProjects()
    }
  }

  func refreshProjects() {
    codeshipApi.getProjects(didRefreshProjects, errorHandler: { error in
      debugPrint(error)
    })
  }

  func refreshCurrentProjects() {
    didRefreshProjects(projects)
  }

  private func didRefreshProjects(projects: [Project]){
    // update our projects hidden state appropriately according to the user settings
    for project in projects {
      project.isEnabled = !settingsManager.disabledProjectIds.contains(project.id)
    }

    self.projects = projects

    for listener in listeners {
      listener(projects)
    }
  }

  func addListener(listener: ProjectHandler){
    listeners.append(listener)
    listener(projects)
  }
}