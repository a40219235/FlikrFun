//
//  UIManagedDocument+Manager.m
//  FlikrFun
//
//  Created by Shane Fu on 10/1/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "UIManagedDocument+Manager.h"

@implementation UIManagedDocument (Manager)

static UIManagedDocument *_defaultDocumentManagerInstance;
+(UIManagedDocument *)defaultManagedDocument{
	if (!_defaultDocumentManagerInstance){
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"DefaultManagedDocumentDatabase"];
        _defaultDocumentManagerInstance = [[UIManagedDocument alloc] initWithFileURL:url];
	}
	return _defaultDocumentManagerInstance;
}

+(void)openDefaultManagedDocumentWithCompletionHandler:(void (^)(BOOL))completionHandler{
	UIManagedDocument *defaultManagedDocument = [UIManagedDocument defaultManagedDocument];
	if (![[NSFileManager defaultManager] fileExistsAtPath:[defaultManagedDocument.fileURL path]]) {
		[defaultManagedDocument saveToURL:defaultManagedDocument.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
			NSLog(@"defaultManagedDocument1 = %@", defaultManagedDocument);
			completionHandler(success);
		}];
	}else if (defaultManagedDocument.documentState == UIDocumentStateClosed){
		[defaultManagedDocument openWithCompletionHandler:^(BOOL success) {
			NSLog(@"defaultManagedDocument2 = %@", defaultManagedDocument);
			completionHandler(success);
		}];
	}else if (defaultManagedDocument.documentState == UIDocumentStateNormal){
		NSLog(@"defaultManagedDocument3 = %@", defaultManagedDocument);
		completionHandler(YES);
	}
}

@end
