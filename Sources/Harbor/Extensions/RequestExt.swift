import Foundation
import Alamofire
import BrightFutures
import SwiftyJSON

struct NetworkError: Error {
  let statusCode: Int
  let response: String?
}

extension DataRequest {
  func decodedResponse<R, E>(
    _ type: R.Type,
    onError: @escaping (Error) -> E,
    decoder: JSONDecoder = JSONDecoder()
  ) -> Future<R, E> where R: Decodable, E: Error {
    let serializer = ResponseSerializers.decodable(
      type: type,
      decoder: decoder
    )

    return Future { complete in
      self.response(responseSerializer: serializer) { response in
        switch response.result {
          case .success(let decoded):
            complete(.success(decoded))
          case .failure(let error):
            complete(.failure(onError(error)))
        }
      }
    }
  }
}

private struct ResponseSerializers {
  static func decodable<T: Decodable>(
    type: T.Type,
    decoder: JSONDecoder
  ) -> DataResponseSerializer<T> {
    return DataResponseSerializer { request, response, data, error in
      if let error = error {
        return .failure(error)
      }

      // fail if there is no data
      guard
        let response = response,
        let data = data, data.count > 0
        else {
          return .failure(serializationFailed(.inputDataNilOrZeroLength))
        }

      // fail if the status code is in the error range
      guard
        response.statusCode < 400
        else {
          return .failure(requestFailed(response, data))
        }

      // try to deserialize the data
      let decodable: T
      do {
        decodable = try decoder.decode(type, from: data)
      } catch {
        return .failure(serializationFailed(.jsonSerializationFailed(error: error)))
      }

      return .success(decodable)
    }
  }

  // helpers
  static func requestFailed(
    _ response: HTTPURLResponse,
    _ data: Data
  ) -> Error {
    return NetworkError(
      statusCode: response.statusCode,
      response: String(data: data, encoding: .utf8)
    )
  }

  static func serializationFailed(
    _ reason: AFError.ResponseSerializationFailureReason
  ) -> Error {
    return AFError.responseSerializationFailed(reason: reason)
  }
}
