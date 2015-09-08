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
    
    static let apiKey = ""
    static let apiURL = "https://codeship.com/api/v1/projects.json?api_key=b02bb166df85e6369d81824a8e32a0535e677299a381ec3877b4871a8285"
    
    class func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->()){
        Alamofire.request(.GET, apiURL).responseCollection{(_, _, result: Result<[Project]> ) in
            
            if (result.isSuccess) {
                successHandler(result.value!)
            } else {
               //log the error
                debugPrint(result.data!)
                errorHandler("Error!")
            }
        }

    }
    
    
}