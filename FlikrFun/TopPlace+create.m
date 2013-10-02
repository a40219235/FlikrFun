//
//  TopPlace+create.m
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "TopPlace+create.h"
#import "FlickrFetcher.h"
#import "UIManagedDocument+Manager.h"

@implementation TopPlace (create)

+(TopPlace *)createTopPlaceWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context{
	TopPlace *topPlace;
	
	if (!context) {
		context = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	}
	
	//fetch request to check if existence before adding to the context
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TopPlace"];
	request.predicate = [NSPredicate predicateWithFormat:@"uniquePlaceID = %@", [flickrInfo objectForKey:FLICKR_PLACE_ID]];
	NSSortDescriptor *sortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"woeName" ascending:YES];
	request.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
	
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || [matches count] > 1) {
		NSAssert(matches, @"matches is nil");
		NSAssert([matches count] > 1, @"matches count = %d", [matches count]);
	}else if ([matches count] == 0){
		topPlace = [NSEntityDescription insertNewObjectForEntityForName:@"TopPlace" inManagedObjectContext:context];
		topPlace.uniquePlaceID = [flickrInfo objectForKey:FLICKR_PLACE_ID];
		topPlace.placeName = [flickrInfo objectForKey:FLICKR_PLACE_NAME];
		topPlace.woeName = [flickrInfo valueForKeyPath:FLICKR_WOE_NAME];
	}else{
		topPlace = [matches lastObject];
	}
	return topPlace;
}

@end
