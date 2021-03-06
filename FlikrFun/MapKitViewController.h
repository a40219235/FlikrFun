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

@protocol MapKitViewControllerDelegate<NSObject>

@optional
-(UIImage *)MapKitViewController:(MapKitViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
-(void)MapKitViewController:(MapKitViewController *)sender annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

@end

@interface MapKitViewController : UIViewController

@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic) CLLocationCoordinate2D center;
@property (nonatomic) MKCoordinateSpan span;
@property (nonatomic) BOOL shouldZoomAfterLoading;

@property (nonatomic, weak) id <MapKitViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
