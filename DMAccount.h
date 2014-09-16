//
//  DMAccount.h
//  Harbor
//
//  Created by Erin Hochstatter on 9/15/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMProject;

@interface DMAccount : NSManagedObject

@property (nonatomic, retain) NSString * apiKey;
@property (nonatomic, retain) NSString * refreshRate;
@property (nonatomic, retain) NSString * accountDescription;
@property (nonatomic, retain) NSSet *projects;
@end

@interface DMAccount (CoreDataGeneratedAccessors)

- (void)addProjectsObject:(DMProject *)value;
- (void)removeProjectsObject:(DMProject *)value;
- (void)addProjects:(NSSet *)values;
- (void)removeProjects:(NSSet *)values;

@end
