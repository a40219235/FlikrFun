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
	if (!context) {
		context = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	}
	
	NSString *title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
	NSString *subtitle = [flickrInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
	NSURL *url = [FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge];

	return [self createPhotoWithImageURL:url title:title subtitle:subtitle inManagedObjectContext:context];
}

+(Photo *)createPhotoWithImageURL:(NSURL *)url title:(NSString *)title subtitle:(NSString *)subtitle inManagedObjectContext:(NSManagedObjectContext *)context{
	Photo *photo;
	
	if (!context) {
		context = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	}
	
	//fetch request to check if existence before adding to the context
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
	request.predicate = [NSPredicate predicateWithFormat:@"imageURL = %@", [url absoluteString]];
	NSSortDescriptor *sortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
	request.sortDescriptors = [NSArray arrayWithObject:sortDiscriptor];
	
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	
	if (!matches || [matches count] > 1) {
		NSAssert(matches, @"matches is nil");
		NSAssert([matches count] > 1, @"matches count = %d", [matches count]);
	}else if ([matches count] == 0){
		photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
		photo.title = title;
		photo.subtitle = subtitle;
		photo.imageURL = [url absoluteString];
	}else{
		photo = [matches lastObject];
	}
	photo.dateViewing = [NSDate date];
	return photo;
	
}

@end
