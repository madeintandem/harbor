import BrightFutures

struct Auth {
  // service
  typealias Service =
    (_ params: Params) -> Future<Session, Failure>

  // input
  struct Params {
    let email: String
    let password: String
  }

  // output
  enum Failure: Error {
    case network(Error?)
  }
}
