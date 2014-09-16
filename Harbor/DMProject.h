//
//  DMProject.h
//  Harbor
//
//  Created by Erin Hochstatter on 8/26/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DMAccount, DMBuild;

@interface DMProject : NSManagedObject

@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * repositoryName;
@property (nonatomic, retain) DMAccount *account;
@property (nonatomic, retain) NSSet *builds;
@end

@interface DMProject (CoreDataGeneratedAccessors)

- (void)addBuildsObject:(DMBuild *)value;
- (void)removeBuildsObject:(DMBuild *)value;
- (void)addBuilds:(NSSet *)values;
- (void)removeBuilds:(NSSet *)values;

@end
