//
//  MapKitViewController.h
//  FlikrFun
//
//  Created by Shane Fu on 9/28/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class MapKitViewController;

@protocol MapKitViewControllerDelegate

-(UIImage *)MapKitViewController:(MapKitViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface MapKitViewController : UIViewController

@property (nonatomic, strong) NSArray *annotations;

@property (nonatomic, weak) id <MapKitViewControllerDelegate> delegate;

@end
