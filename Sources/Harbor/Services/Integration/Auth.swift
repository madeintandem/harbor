import BrightFutures

public struct Auth {
  // service
  public typealias Service =
    (_ params: Params) -> Future<Session, Failure>

  // input
  public struct Params {
    let email: String
    let password: String
  }

  // output
  public enum Failure: Error {
    case network(Error?)
    case unauthorized
    case invalidSessionData
  }
}
