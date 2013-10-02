//
//  Photo+Create.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "Photo.h"

@interface Photo (Create)

//use default managed document context if context is nil
+(Photo *)createPhotoWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
