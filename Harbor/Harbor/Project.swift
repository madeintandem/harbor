//
//  Project.swift
//  Harbor
//
//  Created by Erin Hochstatter on 6/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import Alamofire

public final class Project: ResponseObjectSerializable, ResponseCollectionSerializable, Equatable {
    
    let id: Int
    let uuid: String
    let repositoryName: String
    var builds: [Build]
    let status : Int
    var isEnabled : Bool
    
    public init(id: Int) {
        self.id = id
        self.uuid = NSUUID().UUIDString
        self.repositoryName = ""
        self.builds = [Build]()
        self.status = 0
        self.isEnabled = false
    }
    
    public init?(response:NSHTTPURLResponse, representation:AnyObject){
        self.id = representation.valueForKeyPath("id") as! Int
        self.uuid = representation.valueForKeyPath("uuid") as! String
        self.builds = Build.collection(response: response, representation: representation)
        self.builds.sortInPlace({ $0.startedAt!.compare($1.startedAt!) == .OrderedDescending })
        self.isEnabled = true

        if representation.valueForKeyPath("repository_name") === NSNull(){
            self.repositoryName = "Unnamed Project"
        } else {
            self.repositoryName = representation.valueForKeyPath("repository_name") as! String
        }

        let firstBuild = self.builds.first
        //make this an enum
        if firstBuild?.status == "success" {
            self.status = 0
        } else if firstBuild?.status == "error" {
            self.status = 1
        } else {
            self.status = 2
        }
        
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Project] {
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

public func ==(lhs: Project, rhs: Project) -> Bool {
    return lhs.id == rhs.id
}
