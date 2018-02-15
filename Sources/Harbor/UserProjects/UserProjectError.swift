import BrightFutures

typealias UserProjectFuture<V>
  = Future<V, UserProjectError>

enum UserProjectError: Error {
  case network(Error)
}
