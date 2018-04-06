import BrightFutures

extension User {
  typealias AnySignIn
    = (String, String) -> Future<User, SignIn.Failure>

  public final class SignIn {
    private let auth: Auth.Service
    private let dataStore: Store
    private let keyStore: Store

    public convenience init() {
      self.init(
        auth: CodeshipAuth().call,
        dataStore: FileStore(),
        keyStore: KeychainStore()
      )
    }

    init(
      auth: @escaping Auth.Service,
      dataStore: Store,
      keyStore: Store
    ) {
      self.auth = auth
      self.dataStore = dataStore
      self.keyStore = keyStore
    }

    public func call(email: String, password: String) -> Future<User, Failure> {
      let credentials = Credentials(
        email: email,
        password: password
      )

      return auth(credentials)
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

    // failure
    public enum Failure: Error {
      case auth(Error)
    }
  }
}
