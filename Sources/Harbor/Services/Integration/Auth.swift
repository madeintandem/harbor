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

    // children
    struct Organization: Decodable {
      let id: String
      let name: String
    }
  }
}
