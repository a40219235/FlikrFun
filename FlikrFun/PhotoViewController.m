//
//  PhotoViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/26/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation PhotoViewController

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
//	self.photoImageView.contentMode = UIViewContentModeTopLeft;
	self.photoImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	NSLog(@"self.photoURL = %@", self.photoURL);
	self.photoScrollView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
	//using autoLayout so set here
//	self.photoScrollView.contentSize = CGSizeMake(self.photoImageView.image.size.width,  self.photoImageView.image.size.width);
	NSLog(@"image bounds width = %f, height = %f", self.photoImageView.bounds.size.width, self.photoImageView.bounds.size.height);
	NSLog(@"image size   width = %f, height = %f", self.photoImageView.image.size.width, self.photoImageView.image.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//	self.photoImageView.frame = CGRectMake(0, 0, self.photoImageView.image.size.width, self.photoImageView.image.size.height);
//	self.photoScrollView.contentSize = self.photoImageView.image.size;
//	self.photoScrollView.scrollEnabled = YES;
}

#pragma mark - UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return self.photoImageView;
}

@end
