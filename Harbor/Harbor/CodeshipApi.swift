//
//  CodeshipApi.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/6/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Alamofire

class CodeshipApi: NSObject {
    
    static let apiKey = KeychainWrapper.stringForKey("APIKey")
    static let apiRootPath = "https://codeship.com/api/v1/projects.json?api_key="
    
    class func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->()){
        let apiURL = "\(apiRootPath)\(apiKey!)"
        Alamofire.request(.GET, apiURL).responseCollection{(_, _, result: Result<[Project]> ) in
            
            if (result.isSuccess) {
                successHandler(result.value!)
            } else {
               //log the error
                debugPrint(result)
                errorHandler("Error!")
            }
        }

    }
    
    
}