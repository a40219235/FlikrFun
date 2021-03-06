//
//  PhotoViewController.h
//  FlikrFun
//
//  Created by Shane Fu on 9/27/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

@property(nonatomic, strong) NSURL *photoURL;
@property(nonatomic, strong) NSString *imageTitle;
@property(nonatomic, strong) NSString *imageSubtitle;

@end
