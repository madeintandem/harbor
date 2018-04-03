import BrightFutures

extension User {
  typealias AnySignInCurrent
    = () -> Future<User, SignInCurrent.Failure>

  final class SignInCurrent {
    private let users: UserRepo
    private let store: Store
    private let signIn: AnySignIn

    convenience init() {
      self.init(
        users: UserRepo(),
        store: KeychainStore(),
        signIn: SignIn().call
      )
    }

    init(
      users: UserRepo,
      store: Store,
      signIn: @escaping AnySignIn
    ) {
      self.users = users
      self.store = store
      self.signIn = signIn
    }

    func call() -> Future<User, Failure> {
      if let user = users.current {
        return .init(value: user)
      }

      // fail if no credentials
      guard
        let credentials = store.load(type: Credentials.self, key: .credentials)
        else {
          return .init(error: .noCredentials)
        }

      // re-auth if session is invalid
      guard
        let session = store.load(type: Session.self, key: .session),
        session.isActive
        else {
          return self
            .signIn(credentials.email, credentials.password)
            .mapError(Failure.signIn)
        }

      // otherwise, restore user with an active session and "sign-in"
      let user = User(email: credentials.email)
      user.signIn(with: session)
      Current.user = user

      return .init(value: user)
    }

    enum Failure: Error {
      case noCredentials
      case signIn(Error)
    }
  }
}
