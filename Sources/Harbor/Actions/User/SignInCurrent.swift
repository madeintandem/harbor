import BrightFutures

extension User {
  public final class SignInCurrent {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case noCredentials
      case signIn(Error)
    }

    // MARK: Action
    private let users: UserRepo
    private let dataStore: Store
    private let keyStore: Store

    public convenience init() {
      self.init(
        users: UserRepo(),
        dataStore: FileStore(),
        keyStore: KeychainStore()
      )
    }

    init(
      users: UserRepo,
      dataStore: Store,
      keyStore: Store
    ) {
      self.users = users
      self.dataStore = dataStore
      self.keyStore = keyStore
    }

    public func call() -> Payload {
      if let user = users.current {
        return .init(value: user)
      }

      // fail if no credentials
      guard
        let credentials = keyStore.load(Credentials.self, key: .credentials)
        else {
          return .init(error: .noCredentials)
        }

      // re-auth if session is invalid
      guard
        let user = dataStore.load(User.self, key: .user),
        let session = user.session,
        session.isActive
        else {
          return SignIn()
            .call(email: credentials.email, password: credentials.password)
            .mapError(Failure.signIn)
        }

      // otherwise, just set the current user
      Current.user = user

      return .init(value: user)
    }
  }
}
