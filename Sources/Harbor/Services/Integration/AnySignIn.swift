import BrightFutures

// input
struct SignInParams {
  let email: String
  let password: String
}

// output
typealias SignInFuture<R>
  = Future<R, SignInError>

enum SignInError: Error {
  case network(Error?)
}

// service
protocol AnySignIn {
  func call(_ params: SignInParams) -> SignInFuture<Session>
}
