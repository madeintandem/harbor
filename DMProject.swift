//
//  DMProject.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
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
