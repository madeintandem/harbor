extension User {
  final class SignIn {
    private let users: UserRepo
    private let signIn: AnySignIn

    init(
      users: UserRepo = UserRepo(),
      signIn: AnySignIn = CodeshipSignIn()
    ) {
      self.users = users
      self.signIn = signIn
    }

    func call(params: SignInParams) -> SignInFuture<User?> {
      let user = users.current

      return signIn.call(params).map { session in
        user?.signIn(with: session)
        return user
      }
    }
  }
}
