import BrightFutures

extension User {
  public final class ListProjects {
    private let signIn: AnySignInCurrent

    public convenience init() {
      self.init(
        signIn: SignInCurrent().call
      )
    }

    init(signIn: @escaping AnySignInCurrent) {
      self.signIn = signIn
    }

    public func call() -> Future<[Project], Failure> {
      return self
        .signIn()
        .mapError(Failure.signIn)
        .flatMap { user in
          return .init(value: [] as [Project])
        }
    }

    public enum Failure: Error {
      case signIn(Error)
      case fetchProjects(Error)
    }
  }
}
