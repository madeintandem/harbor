class ServiceModule: AppModule {
  func inject() -> CodeshipApiType {
    return transient {
      CodeshipApi(settings: $0.interactor.inject())
    }
  }
}