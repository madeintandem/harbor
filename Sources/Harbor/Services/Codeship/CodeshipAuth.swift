import Foundation
import Alamofire
import BrightFutures

final class CodeshipAuth {
  private let decoder = JSONDecoder()

  func call(
    with credentials: Credentials
  ) -> Future<Auth.Response, Auth.Failure> {
    guard
      let headers = buildHeaders(from: credentials)
      else {
        return .init(error: .unauthorized)
      }

    return Alamofire
      .request(
        CodeshipUrl.auth,
        method: .post,
        headers: headers
      )
      .decodedResponse(
        Auth.Response.self,
        onError: mapNetworkError,
        decoder: buildDecoder()
      )
  }

  // helpers
  private func buildHeaders(from credentials: Credentials) -> [String: String]? {
    guard let authorization = encodeAuthorization(from: credentials) else {
      return nil
    }

    return [
      "Authorization": "Basic \(authorization)",
    ]
  }

  private func encodeAuthorization(from credentials: Credentials) -> String? {
    return "\(credentials.email):\(credentials.password)"
      .data(using: .utf8)?
      .base64EncodedString()
  }

  private func buildDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .secondsSince1970
    return decoder
  }

  private func mapNetworkError(error: Error) -> Auth.Failure {
    if let error = error as? NetworkError, error.statusCode == 401 {
      return .unauthorized
    }

    return .network(error)
  }
}
