//
//  MapKitViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/28/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "MapKitViewController.h"

@interface MapKitViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapKitViewController
@synthesize annotations = _annotations;
@synthesize mapView = _mapView;

#pragma -mark setters and getters
-(void)setAnnotations:(NSArray *)annotations{
	if (![_annotations isEqualToArray:annotations]) {
		_annotations = annotations;
		[self updateMapView];
	}
}

-(void)setMapView:(MKMapView *)mapView{
	if (![_mapView isEqual:mapView]) {
		_mapView = mapView;
		[self updateMapView];
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.mapView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) updateMapView{
	if (self.mapView.annotations) {
		[self.mapView removeAnnotations:self.mapView.annotations];
	}
	if (self.annotations) {
		[self.mapView addAnnotations:self.annotations];
	}
}

#pragma -mark MKMapViewDelegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
	MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
	if (!annotationView) {
		annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
		annotationView.canShowCallout = YES;
		annotationView.enabled = YES;
		annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	}
	[(UIImageView *)annotationView.leftCalloutAccessoryView setImage:nil];
	annotationView.annotation = annotation;
	return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
	UIImage *image = [self.delegate MapKitViewController:self imageForAnnotation:view.annotation];
	[(UIImageView *)view.leftCalloutAccessoryView setImage:image];
}

@end
