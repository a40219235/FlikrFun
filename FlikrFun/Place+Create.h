//
//  Place+Create.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Place.h"

@interface Place (Create)

+(Place *)placeWithName:(NSString *)name InManagedContext:(NSManagedObjectContext *)context;

@end
