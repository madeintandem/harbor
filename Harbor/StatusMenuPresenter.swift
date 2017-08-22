import Foundation

class StatusMenuPresenter<V: StatusMenuView> : Presenter<V> {
  //
  // MARK: Dependencies
  fileprivate let projectsInteractor: ProjectsInteractor
  fileprivate let settings: SettingsType

  //
  // MARK: Properties
  init(view: V, projectsInteractor: ProjectsInteractor, settings: SettingsType) {
    self.projectsInteractor = projectsInteractor
    self.settings = settings

    super.init(view: view)
  }

  required init(view: V) {
      fatalError("init(view:) has not been implemented")
  }

  override func didInitialize() {
    super.didInitialize()

    view.createCoreMenuItems()
    projectsInteractor.addListener(self.handleProjects)
  }

  //
  // MARK: Projects
  fileprivate func handleProjects(_ projects: [Project]) {
    // filter out projects the user disabled and convert them to menu item models
    let disabledProjectIds = settings.disabledProjectIds
    let enabledProjects = projects
      .filter { !disabledProjectIds.contains($0.id) }
      .map { ProjectMenuItemModel(project: $0) }

    view.updateProjects(enabledProjects)
    view.updateBuildStatus(self.buildStatusFromProjects(enabledProjects))
  }

  fileprivate func buildStatusFromProjects(_ projects: [ProjectMenuItemModel]) -> Build.Status {
    if projects.count == 0 {
      return .Unknown
    } else if (projects.any { $0.isFailing }) {
      return .Failing
    } else if (projects.any { $0.isBuilding }) {
      return .Building
    } else {
      return .Passing
    }
  }
}
