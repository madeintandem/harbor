//
//  DMAccount.swift
//  Harbor
//
//  Created by Erin Hochstatter on 1/7/15.
//  Copyright (c) 2015 dvm. All rights reserved.
//

import Foundation
import CoreData

class DMAccount: NSManagedObject {

    @NSManaged var accountDescription: String
    @NSManaged var apiKey: String
    @NSManaged var refreshRate: String?
    @NSManaged var projects: NSSet

}
