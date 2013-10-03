//
//  Country.h
//  FlikrFun
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TopPlace;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * countryName;
@property (nonatomic, retain) NSSet *places;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(TopPlace *)value;
- (void)removePlacesObject:(TopPlace *)value;
- (void)addPlaces:(NSSet *)values;
- (void)removePlaces:(NSSet *)values;

@end
