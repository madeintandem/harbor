import BrightFutures

typealias UserFuture<V>
  = Future<V, UserError>

enum UserError: Error {
  case network(Error?)
  case notSignedIn
  case blankCredentials
}
