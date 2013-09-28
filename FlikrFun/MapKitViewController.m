//
//  MapKitViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/28/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "MapKitViewController.h"

@interface MapKitViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapKitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
