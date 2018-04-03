import BrightFutures

public struct Auth {
  // service
  typealias Service =
    (_ params: Credentials) -> Future<Session, Failure>

  // output
  public enum Failure: Error {
    case network(Error?)
    case unauthorized
    case invalidSessionData
  }
}
