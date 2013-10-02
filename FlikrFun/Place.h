//
//  Place.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo;

@interface Place : NSManagedObject

@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * whoTook;
@property (nonatomic, retain) NSSet *photoes;
@end

@interface Place (CoreDataGeneratedAccessors)

- (void)addPhotoesObject:(Photo *)value;
- (void)removePhotoesObject:(Photo *)value;
- (void)addPhotoes:(NSSet *)values;
- (void)removePhotoes:(NSSet *)values;

@end
