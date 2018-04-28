import BrightFutures

extension User {
  public final class SignInCurrent {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case noCredentials
      case nested(Error)
    }

    // MARK: Action
    private let users: UserRepo
    private let stores: StoreProvider

    public convenience init() {
      self.init(users: UserRepo(), stores: Stores())
    }

    init(users: UserRepo, stores: StoreProvider) {
      self.users = users
      self.stores = stores
    }

    public func call() -> Payload {
      if let user = users.current {
        return .init(value: user)
      }

      // fail if no credentials
      guard
        let credentials = stores.secure().load(.credentials)
        else {
          return .init(error: .noCredentials)
        }

      // re-auth if session is invalid
      guard
        let user = stores.data().load(.user),
        let session = user.session,
        session.isActive
        else {
          return SignIn()
            .call(email: credentials.email, password: credentials.password)
            .mapError(Failure.nested)
        }

      // otherwise, just set the current user
      Current.user = user

      return .init(value: user)
    }
  }
}
