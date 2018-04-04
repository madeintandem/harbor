import Alamofire
import BrightFutures

final class CodeshipFetchProjects {
  func call() -> Future<FetchProjects.Response, FetchProjects.Failure> {
    // TODO: SignInCurrent should handle setting the session before
    // this call. do we think it's okay to force unwrap here?
    guard let session = Current.user?.session else {
      return .init(error: .notAuthenticated)
    }

    return Alamofire
      .request(
        CodeshipUrl.projects,
        headers: buildHeaders(from: session)
      )
      .decodedResponse(
        FetchProjects.Response.self,
        onError: FetchProjects.Failure.network
      )
  }

  // helpers
  private func buildHeaders(from session: Session) -> [String: String] {
    return [
      "Authorization": "Bearer \(session.accessToken)",
    ]
  }
}
