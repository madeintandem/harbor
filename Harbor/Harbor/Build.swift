//
//  Build.swift
//  Harbor
//
//  Created by Erin Hochstatter on 7/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

final class Build: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    var id: Int?
    var uuid: String?
    var projectID: Int?
    var status: String?
    var gitHubUsername: String?
    var commitID: String?
    var message: String?
    var branch: String?
    var startedAt: NSString?
    var finishedAt: NSString?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject){
        self.id = representation.valueForKeyPath("id") as? Int
        self.uuid = representation.valueForKeyPath("uuid") as? String
        self.projectID = representation.valueForKeyPath("project_id") as? Int
        self.status = representation.valueForKeyPath("status") as? String
        self.gitHubUsername = representation.valueForKeyPath("github_username") as? String
        self.commitID = representation.valueForKeyPath("commit_id") as? String
        self.message = representation.valueForKeyPath("message") as? String
        self.branch = representation.valueForKeyPath("branch") as? String
        self.startedAt = representation.valueForKeyPath("started_at") as? NSString
        self.finishedAt = representation.valueForKeyPath("finished_at") as? NSString
    }
    
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Build] {
        var builds: [Build] = []
        
        if let representation = representation.valueForKeyPath("builds") as? [[String: AnyObject]] {
            for buildRepresentation in representation {
                if let build = Build(response: response, representation: buildRepresentation) {
                    builds.append(build)
                }
            }
        }
        return builds
    }
}
