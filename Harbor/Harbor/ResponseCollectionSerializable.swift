//
//  ResponseCollectionSerializable.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[T]>) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<[T]> { request, response, data in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data)
            
            switch result {
            case .Success(let value):
                if let response = response {
                    return .Success(T.collection(response: response, representation: value))
                } else {
                    let failureReason = "Response collection could not be serialized due to nil response"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(data, error)
                }
            case .Failure(let data, let error):
                return .Failure(data, error)
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}