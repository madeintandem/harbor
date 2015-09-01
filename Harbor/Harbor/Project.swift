//
//  Project.swift
//  Harbor
//
//  Created by Erin Hochstatter on 6/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Alamofire

final class Project: ResponseObjectSerializable, ResponseCollectionSerializable {
  
    
    let id: Int
    let uuid: String
    let repositoryName: String
    let repositoryProvider: String
    let builds: [Build]
    
    init?(response:NSHTTPURLResponse, representation:AnyObject){
        
        self.id = representation.valueForKeyPath("id") as! Int
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.repositoryName = representation.valueForKeyPath("repository_name") as! String
        self.repositoryProvider = representation.valueForKeyPath("repository_provider") as! String
        self.builds = Build.collection(response: response, representation: representation)
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Project] {
        var projects: [Project] = []
        
        if let representation = representation.valueForKeyPath("projects") as? [[String: AnyObject]] {
            for projectRepresentation in representation {
                if let project = Project(response: response, representation: projectRepresentation) {
                    projects.append(project)
                }
            }
        }
        
        return projects
    }
}
