import Foundation
import Alamofire
import SwiftyJSON

struct CodeshipSignIn: AnySignIn {
  func call(_ params: SignInParams) -> SignInFuture<Session> {
    guard let headers = headers(from: params) else {
      return SignInFuture<Session>(error: .network(nil))
    }

    return Alamofire
      .request(CodeshipUrl.auth, headers: headers)
      .responseJson(onError: SignInError.network)
      .flatMap(self.parseSession)
  }

  // helpers
  private func headers(from params: SignInParams) -> [String: String]? {
    let authorization = "\(params.email):\(params.email)"
      .data(using: .utf8)?
      .base64EncodedString()

    return authorization
      .map { value in ["Authorization": value] }
  }

  private func parseSession(from json: JSON) -> SignInFuture<Session> {
    guard
      let token = json["authorization_token"].string,
      let expiresAt = json["expires_at"].double else {
        return SignInFuture(error: .network(nil))
      }

    let session = Session(
      token: token,
      expiresAt: Date(timeIntervalSince1970: expiresAt)
    )

    return SignInFuture(value: session)
  }
}
