//
//  Place+Create.m
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Place+Create.h"

@implementation Place (Create)

+(Place *)placeWithName:(NSString *)name InManagedContext:(NSManagedObjectContext *)context{
	Place *place ;
	
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
	
}



@end
