import BrightFutures

extension User {
  public final class SignIn {
    private let auth: Auth.Service

    public convenience init() {
      self.init(auth: CodeshipAuth().call)
    }

    init(auth: @escaping Auth.Service) {
      self.auth = auth
    }

    public func call(email: String, password: String) -> Future<User, Auth.Failure> {
      let params = Auth.Params(
        email: email,
        password: password
      )

      return auth(params)
        .map { session in
          let user = User(email: params.email)
          user.signIn(with: session)
          return user
        }
        .onSuccess { user in
          Current.user = user
        }
    }
  }
}
