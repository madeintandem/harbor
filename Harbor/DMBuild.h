//
//  DMBuild.h
//  Harbor
//
//  Created by Erin Hochstatter on 8/26/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DMBuild : NSManagedObject

@property (nonatomic, retain) NSManagedObject *project;

@end
