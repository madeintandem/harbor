//
//  DMAccount.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Foundation
import CoreData

class DMAccount: NSManagedObject {

    @NSManaged var apiKey: String
    @NSManaged var refreshRate: String
    @NSManaged var accountDescription: String
    @NSManaged var projects: NSSet

}
