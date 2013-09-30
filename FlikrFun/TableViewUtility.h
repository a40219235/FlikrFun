//
//  TableViewUtility.h
//  FlikrFun
//
//  Created by Shane Fu on 9/29/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableViewUtility : NSObject

+(void)loadDataUsingBlock:(void(^)(void))dataBlock InQueue:(dispatch_queue_t)queue withComplitionHandler:(void(^)(void))completionHandler;

+(void)LoggingCGSize:(CGSize)size withString:(NSString *)string;

+(void)LoggingCGRect:(CGRect)rect withString:(NSString *)string;

@end
