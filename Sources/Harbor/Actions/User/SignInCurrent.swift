import BrightFutures

extension User {
  public final class SignInCurrent {
    private let users: UserRepo
    private let dataStore: Store
    private let secureStore: Store
    private let signIn: AnySignIn

    public convenience init() {
      self.init(
        users: UserRepo(),
        dataStore: FileStore(),
        secureStore: KeychainStore(),
        signIn: SignIn().call
      )
    }

    init(
      users: UserRepo,
      dataStore: Store,
      secureStore: Store,
      signIn: @escaping AnySignIn
    ) {
      self.users = users
      self.dataStore = dataStore
      self.secureStore = secureStore
      self.signIn = signIn
    }

    public func call() -> Future<User, Failure> {
      if let user = users.current {
        return .init(value: user)
      }

      // fail if no credentials
      guard
        let credentials = secureStore.load(Credentials.self, key: .credentials)
        else {
          return .init(error: .noCredentials)
        }

      // re-auth if session is invalid
      guard
        let user = dataStore.load(User.self, key: .user),
        let session = user.session,
        session.isActive
        else {
          return self
            .signIn(credentials.email, credentials.password)
            .mapError(Failure.signIn)
        }

      // otherwise, just set the current user
      Current.user = user

      return .init(value: user)
    }

    public enum Failure: Error {
      case noCredentials
      case signIn(Error)
    }
  }
}
