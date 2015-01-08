//
//  DMProject.swift
//  Harbor
//
//  Created by Erin Hochstatter on 1/7/15.
//  Copyright (c) 2015 dvm. All rights reserved.
//

import Foundation
import CoreData

class DMProject: NSManagedObject {

    @NSManaged var active: NSNumber
    @NSManaged var id: String
    @NSManaged var repositoryName: String
    @NSManaged var account: DMAccount
    @NSManaged var builds: NSSet

}
