import BrightFutures

extension User {
  final class SignIn {
    private let auth: Auth.Service

    init(
      auth: @escaping Auth.Service = CodeshipAuth().call
    ) {
      self.auth = auth
    }

    func call(_ params: Auth.Params) -> Future<User, Auth.Failure> {
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
