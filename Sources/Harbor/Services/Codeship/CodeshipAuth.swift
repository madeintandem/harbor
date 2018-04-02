import Foundation
import Alamofire
import BrightFutures
import SwiftyJSON

final class CodeshipAuth {
  func call(_ params: Auth.Params) -> Future<Session, Auth.Failure> {
    guard let headers = headers(from: params) else {
      return .init(error: .network(nil))
    }

    return Alamofire
      .request(CodeshipUrl.auth, headers: headers)
      .responseJson(onError: Auth.Failure.network)
      .flatMap(self.parseSession)
  }

  // helpers
  private func headers(from params: Auth.Params) -> [String: String]? {
    let authorization = "\(params.email):\(params.email)"
      .data(using: .utf8)?
      .base64EncodedString()

    return authorization
      .map { value in ["Authorization": value] }
  }

  private func parseSession(from json: JSON) -> Future<Session, Auth.Failure> {
    guard
      let token = json["authorization_token"].string,
      let expiresAt = json["expires_at"].double else {
        return .init(error: .network(nil))
      }

    let session = Session(
      token: token,
      expiresAt: Date(timeIntervalSince1970: expiresAt)
    )

    return .init(value: session)
  }
}
