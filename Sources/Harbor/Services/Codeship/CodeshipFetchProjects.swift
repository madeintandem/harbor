import Foundation
import Alamofire
import BrightFutures

final class CodeshipFetchProjects {
  func call() -> Future<FetchProjects.Response, FetchProjects.Failure> {
    // TODO: SignInCurrent should handle setting the session before
    // this call. do we think it's okay to force unwrap here?
    guard
      let user = Current.user,
      let session = user.session
      else {
        return .init(error: .notAuthenticated)
      }

    guard let organization = user.organizations.first else {
      return .init(error: .noOrganization)
    }

    return Alamofire
      .request(
        CodeshipUrl.projects(organization.id),
        headers: buildHeaders(from: session)
      )
      .decodedResponse(
        FetchProjects.Response.self,
        onError: FetchProjects.Failure.network,
        decoder: buildDecoder()
      )
  }

  // helpers
  private func buildHeaders(from session: Session) -> [String: String] {
    return [
      "Authorization": "Bearer \(session.accessToken)",
    ]
  }

  private func buildDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
    return decoder
  }
}
