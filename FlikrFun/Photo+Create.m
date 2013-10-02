//
//  Photo+Create.m
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Photo+Create.h"
#import "FlickrFetcher.h"
#import "Place.h"
#import "UIManagedDocument+Manager.h"

@implementation Photo (Create)

+(Photo *)createPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context{
	Photo *photo;
	
	if (!context) {
		context = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	}
	
	//fetch request to check if existence before adding to the context
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
	request.predicate = [NSPredicate predicateWithFormat:@"uniqueID = %@", [flickrInfo objectForKey:FLICKR_PHOTO_ID]];
	NSSortDescriptor *sortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	request.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
	
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || [matches count] > 1) {
		NSAssert(matches, @"matches is nil");
		NSAssert([matches count] > 1, @"matches count = %d", [matches count]);
	}else if ([matches count] == 0){
		photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
		photo.uniqueID = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
		photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
		photo.subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
		photo.imageURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
	}else{
		photo = [matches lastObject];
	}
	return photo;
}

@end
