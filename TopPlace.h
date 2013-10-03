//
//  TopPlace.h
//  FlikrFun
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country;

@interface TopPlace : NSManagedObject

@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * uniquePlaceID;
@property (nonatomic, retain) NSString * woeName;
@property (nonatomic, retain) NSNumber * longtitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) Country *country;

@end
