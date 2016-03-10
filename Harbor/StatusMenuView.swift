protocol StatusMenuView : ViewType {
  func createCoreMenuItems()
  func updateBuildStatus(status: BuildStatus)
  func updateProjects(projects: [ProjectMenuItemModel])
}