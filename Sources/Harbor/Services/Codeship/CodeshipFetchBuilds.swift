import Foundation
import Alamofire
import BrightFutures

final class CodeshipFetchBuilds {
  func call(
    for organization: Organization,
    project: Project
  ) -> Future<FetchBuilds.Response, FetchBuilds.Failure> {
    guard let session = Current.user?.session else {
      return .init(error: .unauthenticated)
    }

    return Alamofire
      .request(
        CodeshipUrl.builds(organization, project),
        headers: buildHeaders(from: session)
      )
      .decodedResponse(
        FetchBuilds.Response.self,
        onError: FetchBuilds.Failure.network,
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
