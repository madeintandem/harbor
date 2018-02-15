import BrightFutures

protocol UserSessionProvider {
  func create(with params: UserSessionParams) -> UserFuture<Session>
}

class UserSessionRepo {
  private let provider: UserSessionProvider

  init(provider: UserSessionProvider) {
    self.provider = provider
  }

  func create (with params: UserSessionParams) -> UserFuture<Session> {
    return provider.create(with: params)
  }
}
