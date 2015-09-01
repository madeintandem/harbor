//
//  ResponseObjectSerializable.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Alamofire

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<T>) -> Void) -> Self {
        let responseSerializer = GenericResponseSerializer<T> { request, response, data in
            let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONResponseSerializer.serializeResponse(request, response, data)
            
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
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