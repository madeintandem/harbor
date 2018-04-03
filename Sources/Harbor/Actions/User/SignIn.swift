import BrightFutures

extension User {
  public final class SignIn {
    private let auth: Auth.Service
    private let store: Store

    public convenience init() {
      self.init(
        auth: CodeshipAuth().call,
        store: KeychainStore()
      )
    }

    init(auth: @escaping Auth.Service, store: Store) {
      self.auth = auth
      self.store = store
    }

    public func call(email: String, password: String) -> Future<User, Auth.Failure> {
      let credentials = Credentials(
        email: email,
        password: password
      )

      return auth(credentials)
        .map { session in
          let user = User(email: credentials.email)
          user.signIn(with: session)
          return user
        }
        .onSuccess { user in
          Current.user = user
          self.store.save(entity: credentials, as: .credentials)
        }
    }
  }
}
