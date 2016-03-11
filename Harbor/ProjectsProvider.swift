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

    self.settingsManager.observeNotification(.ApiKey) { _ in
      self.refreshProjects()
    }

    self.settingsManager.observeNotification(.DisabledProjects) { _ in
      self.refreshCurrentProjects()
    }
  }

  func refreshProjects() {
    self.codeshipApi.getProjects(didRefreshProjects, errorHandler: { error in
      debugPrint(error)
    })
  }

  func refreshCurrentProjects() {
    self.didRefreshProjects(self.projects)
  }

  private func didRefreshProjects(projects: [Project]){
    // update our projects hidden state appropriately according to the user settings
    for project in projects {
      project.isEnabled = !self.settingsManager.disabledProjectIds.contains(project.id)
    }

    self.projects = projects

    for listener in self.listeners {
      listener(projects)
    }
  }

  func addListener(listener: ProjectHandler){
    self.listeners.append(listener)
    listener(self.projects)
  }
}