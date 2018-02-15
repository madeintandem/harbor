import Foundation
import Alamofire
import SwiftyJSON

final class CodeshipUserSessionProvider: UserSessionProvider {
  func create(with params: UserSessionParams) -> UserFuture<Session> {
    guard let headers = headers(from: params) else {
      return UserFuture<Session>(error: .network(nil))
    }

    return Alamofire
      .request(CodeshipUrl.auth, headers: headers)
      .responseJson(onError: UserError.network)
      .flatMap(self.parseSession)
  }

  private func headers(from params: UserSessionParams) -> [String: String]? {
    let authorization = "\(params.email):\(params.email)"
      .data(using: .utf8)?
      .base64EncodedString()

    return authorization
      .map { value in ["Authorization": value] }
  }

  private func parseSession(from json: JSON) -> UserFuture<Session> {
    guard
      let token = json["authorization_token"].string,
      let expiresAt = json["expires_at"].double else {
        return UserFuture(error: .network(nil))
      }

    let session = Session(
      token: token,
      expiresAt: Date(timeIntervalSince1970: expiresAt)
    )

    return UserFuture(value: session)
  }
}
