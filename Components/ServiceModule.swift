
class ServiceModule: AppModule {
  func inject() -> CodeshipApiType {
    return transient { component in
      CodeshipApi(settings: component.interactor.inject()) as CodeshipApiType
    }
  }
}
