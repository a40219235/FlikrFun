//
//  FlikrerPhotoAnnotation.m
//  FlikrFun
//
//  Created by Shane Fu on 9/28/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "FlikrerPhotoAnnotation.h"
#import "FlickrFetcher.h"


@implementation FlikrerPhotoAnnotation

+(FlikrerPhotoAnnotation *)annotationForPhotoes:(NSDictionary *)photoes{
//	NSLog(@"photoes receive  = %@", photoes);
	FlikrerPhotoAnnotation *annotation = [[FlikrerPhotoAnnotation alloc] init];
	annotation.photoes = photoes;
	return annotation;
}

-(NSString *)title{
	NSString *title = [self.photoes objectForKey:FLICKR_PHOTO_TITLE];
	if (![title length]) {
		title = [self.photoes objectForKey:FLICKR_WOE_NAME];
		if (![title length]){
			title = [self.photoes valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
			if (![title length]) {
				title = @"Unknown";
			}
		}
	}
	
	return title;
}

-(NSString *)subtitle{
	NSString *subtitle = [self.photoes valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
	if (![subtitle length]) {
		subtitle = [self.photoes objectForKey:FLICKR_PLACE_NAME];
	}
	return subtitle;
}

-(CLLocationCoordinate2D)coordinate{
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = [[self.photoes objectForKey:FLICKR_LATITUDE] doubleValue];
	coordinate.longitude = [[self.photoes objectForKey:FLICKR_LONGITUDE] doubleValue];
	return coordinate;
}

@end
