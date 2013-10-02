//
//  TopPlace+create.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "TopPlace.h"

@interface TopPlace (create)

//use default managed document context if context is nil
+(TopPlace *)createTopPlaceWithFlickrInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context;

@end
