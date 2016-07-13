
class InteractorModule: AppModule {
  func inject() -> SettingsType {
    return single {
      Settings(
        defaults: $0.system.inject(),
        keychain: $0.system.inject(),
        notificationCenter: $0.system.inject()) as SettingsType
    }
  }

  func inject() -> ProjectsInteractor {
    return single {
      ProjectsProvider(
        api: $0.service.inject(),
        settings: $0.interactor.inject()) as ProjectsInteractor
    }
  }

  func inject() -> TimerCoordinatorType {
    return single {
      TimerCoordinator(
        runLoop: $0.system.inject(),
        projectsInteractor: $0.interactor.inject(),
        settings: $0.interactor.inject()) as TimerCoordinatorType
    }
  }
}
