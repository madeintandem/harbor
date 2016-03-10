//
//  CodeshipApi2.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Alamofire

protocol CodeshipApiType {
    func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->())
}

class CodeshipApi : CodeshipApiType {
    
    static let apiRootPath = "https://codeship.com/api/v1/projects.json?api_key="
    
    private let settingsManager: SettingsManager
    
    init(settingsManager: SettingsManager = core().inject()) {
        self.settingsManager = settingsManager
    }
    
    func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->()){
        let apiKey = self.settingsManager.apiKey
        let apiURL = "\(CodeshipApi.apiRootPath)\(apiKey)"
        
        Alamofire.request(.GET, apiURL).responseCollection{(response: Response<[Project], NSError> ) in

            if(response.result.isSuccess) {
                successHandler(response.result.value!)
            } else {
                //log the error
                debugPrint(response.result)
                errorHandler("Error!")
            }
        }
        
    }
}
