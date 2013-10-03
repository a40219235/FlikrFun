//
//  Photo.h
//  FlikrFun
//
//  Created by Shane Fu on 10/2/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dateViewing;

@end
