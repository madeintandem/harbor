//
//  CodeshipApi2.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Alamofire

public protocol CodeshipApiType {
    func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->())
}

public class CodeshipApi : CodeshipApiType {
    
    static let apiRootPath = "https://codeship.com/api/v1/projects.json?api_key="
    
    private let settingsManager: SettingsManager
    
    public init(settingsManager: SettingsManager = core().inject()) {
        self.settingsManager = settingsManager
    }
    
    public func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->()){
        let apiKey = self.settingsManager.apiKey
        let apiURL = "\(CodeshipApi.apiRootPath)\(apiKey)"
        
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
