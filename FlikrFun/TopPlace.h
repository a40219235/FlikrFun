//
//  TopPlace.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TopPlace : NSManagedObject

@property (nonatomic, retain) NSString * uniquePlaceID;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSString * woeName;

@end
