import Foundation
import BrightFutures

struct Auth {
  // service
  typealias Service =
    (_ params: Credentials) -> Future<Response, Failure>

  // output
  enum Failure: Error {
    case unauthorized
    case invalidSessionData
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
