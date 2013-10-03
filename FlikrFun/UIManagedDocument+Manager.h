//
//  UIManagedDocument+Manager.h
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIManagedDocument (Manager)

+(UIManagedDocument *)defaultManagedDocument;

+(void)openDefaultManagedDocumentWithCompletionHandler:(void(^)(BOOL success))completionHandler;

@end
