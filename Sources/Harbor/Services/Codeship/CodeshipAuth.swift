import Foundation
import Alamofire
import BrightFutures
import SwiftyJSON

final class CodeshipAuth {
  func call(_ params: Auth.Params) -> Future<Session, Auth.Failure> {
    guard let headers = buildHeaders(from: params) else {
      return .init(error: .unauthorized)
    }

    return Alamofire
      .request(CodeshipUrl.auth, method: .post, headers: headers)
      .responseJson(onError: mapNetworkError)
      .flatMap(self.parseSession)
  }

  // helpers
  private func buildHeaders(from params: Auth.Params) -> [String: String]? {
    guard let authorization = encodeAuthorization(from: params) else {
      return nil
    }

    return [
      "Authorization": "Basic \(authorization)",
    ]
  }

  private func encodeAuthorization(from params: Auth.Params) -> String? {
    return "\(params.email):\(params.password)"
      .data(using: .utf8)?
      .base64EncodedString()
  }

  private func mapNetworkError(error: Error) -> Auth.Failure {
    if let error = error as? NetworkError, error.statusCode == 401 {
      return .unauthorized
    }

    return .network(error)
  }

  private func parseSession(from json: JSON) -> Future<Session, Auth.Failure> {
    guard
      let accessToken = json["access_token"].string,
      let expiresAt   = json["expires_at"].double else {
        return .init(error: .invalidSessionData)
      }

    let session = Session(
      accessToken: accessToken,
      expiresAt: Date(timeIntervalSince1970: expiresAt)
    )

    return .init(value: session)
  }
}
