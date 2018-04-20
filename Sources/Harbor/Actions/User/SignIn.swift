import BrightFutures

extension User {
  public final class SignIn {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case auth(Error)
    }

    // MARK: Action
    private let dataStore: Store
    private let keyStore: Store

    public convenience init() {
      self.init(dataStore: FileStore(), keyStore: KeychainStore())
    }

    init(dataStore: Store, keyStore: Store) {
      self.dataStore = dataStore
      self.keyStore = keyStore
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
        .mapError(Failure.auth)
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

          self.dataStore.save(user, as: .user)
          self.keyStore.save(credentials, as: .credentials)
        }
    }
  }
}
