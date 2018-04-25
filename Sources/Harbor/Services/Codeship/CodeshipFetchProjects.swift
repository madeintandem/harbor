import Foundation
import Alamofire
import BrightFutures

final class CodeshipFetchProjects {
  func call(
    for organization: Organization
  ) -> Future<FetchProjects.Response, FetchProjects.Failure> {
    guard let session = Current.user?.session else {
      return .init(error: .unauthenticated)
    }

    return Alamofire
      .request(
        CodeshipUrl.projects(organization),
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
