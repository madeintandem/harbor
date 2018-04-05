import BrightFutures

extension User {
  typealias AnySignIn
    = (String, String) -> Future<User, SignIn.Failure>

  public final class SignIn {
    private let auth: Auth.Service
    private let dataStore: Store
    private let secureStore: Store

    public convenience init() {
      self.init(
        auth: CodeshipAuth().call,
        dataStore: FileStore(),
        secureStore: KeychainStore()
      )
    }

    init(
      auth: @escaping Auth.Service,
      dataStore: Store,
      secureStore: Store
    ) {
      self.auth = auth
      self.dataStore = dataStore
      self.secureStore = secureStore
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
          self.secureStore.save(credentials, as: .credentials)
        }
    }

    // failure
    public enum Failure: Error {
      case auth(Error)
    }
  }
}
