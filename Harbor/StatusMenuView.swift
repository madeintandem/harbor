protocol StatusMenuView : ViewType {
  func createCoreMenuItems()
  func updateBuildStatus(status: Build.Status)
  func updateProjects(projects: [ProjectMenuItemModel])
}