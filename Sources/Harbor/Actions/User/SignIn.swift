import BrightFutures

public extension User {
  public final class SignIn {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case nested(Error)
    }

    // MARK: Action
    private let stores: StoreProvider

    public convenience init() {
      self.init(stores: Stores())
    }

    init(stores: StoreProvider) {
      self.stores = stores
    }

    func call(with credentials: Credentials) -> Payload {
      return call(email: credentials.email, password: credentials.password)
    }

    public func call(email: String, password: String) -> Payload {
      let credentials = Credentials(
        email: email,
        password: password
      )

      return CodeshipAuth()
        .call(with: credentials)
        .mapError(Failure.nested)
        .map { response in
          let user = User(credentials.email)

          user.signIn(
            Session.fromJson(response),
            Organization.fromJson(response.organizations)
          )

          return user
        }
        .onSuccess { user in
          Current.user = user

          self.stores.data().save(.user, record: user)
          self.stores.secure().save(.credentials, record: credentials)
        }
    }
  }
}
