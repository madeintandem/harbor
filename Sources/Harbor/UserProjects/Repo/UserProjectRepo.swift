import BrightFutures

typealias UserProjectFuture<V> =
  Future<V, UserProjectError>

protocol UserProjectProvider {
  func fetch() -> UserProjectFuture<[Project]>
}

class UserProjectRepo {
  private let provider: UserProjectProvider

  init (provider: UserProjectProvider) {
    self.provider = provider
  }

  func all() -> UserProjectFuture<[Project]> {
    return provider.fetch()
  }
}
