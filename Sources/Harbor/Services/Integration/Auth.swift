import Foundation
import BrightFutures

public struct Auth {
  // service
  typealias Service =
    (_ params: Credentials) -> Future<Response, Failure>

  // output
  public enum Failure: Error {
    case badCredentials
    case unauthorized
    case network(Error)
  }

  struct Response: Decodable {
    let accessToken: String
    let expiresAt: Date
    let organizations: [Organization]

    struct Organization: Decodable {
      let uuid: String
      let name: String
    }
  }
}
