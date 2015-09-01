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
    
    let apiKey = ""
    let apiURL = "https://codeship.com/api/v1/projects.json?api_key=b02bb166df85e6369d81824a8e32a0535e677299a381ec3877b4871a8285"
    
    
    func getProjects() -> [Project]{
        var projects : [Project] = []

        Alamofire.request(.GET, apiURL)
            .responseCollection{(_, _, result: Result<[Project]> ) in
                for projectValue in result.value! {
                    print((projectValue as Project).repositoryName)
                    projects .append(projectValue as Project)
                }
        }
        return projects
    }
    
}