class InteractorModule: AppModule {
  func inject() -> SettingsManager {
    return single {
      SettingsManager(
        defaults: $0.system.inject(),
        keychain: $0.system.inject(),
        notificationCenter: $0.system.inject())
    }
  }

  func inject() -> ProjectsInteractor {
    return single {
      ProjectsProvider(
        api: $0.service.inject(),
        settings: $0.interactor.inject())
    }
  }

  func inject() -> TimerCoordinator {
    return single {
      TimerCoordinator(
        runLoop: $0.system.inject(),
        projectsInteractor: $0.interactor.inject(),
        settings: $0.interactor.inject())
    }
  }
}