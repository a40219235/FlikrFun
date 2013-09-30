//
//  TableViewUtility.m
//  FlikrFun
//
//  Created by Shane Fu on 9/29/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "TableViewUtility.h"

@implementation TableViewUtility

+(void)loadDataUsingBlock:(void(^)(void))dataBlock InQueue:(dispatch_queue_t)queue withComplitionHandler:(void(^)(void))completionHandler{
	if (!queue) {
		queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	}
	dispatch_async(queue, ^{
		NSAssert(dataBlock, @"dataBlockIsNil");
		dataBlock();
		dispatch_async(dispatch_get_main_queue(), ^{
			if (completionHandler) {
				completionHandler();
			}
		});
	});
}

+(void)LoggingCGSize:(CGSize)size withString:(NSString *)string{
	NSLog(@"%@.width = %f, %@.height = %f", string, size.width, string, size.height);
}

+(void)LoggingCGRect:(CGRect)rect withString:(NSString *)string{
	NSLog(@"%@ = (%f, %f, %f, %f)", string, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

@end
