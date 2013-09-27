//
//  PhotoViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/27/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

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
	
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.photoURL]];
	self.imageView = [[UIImageView alloc] initWithImage:image];
	self.imageView.frame = CGRectMake(0,0,image.size.width, image.size.height);
	[self.scrollView addSubview:self.imageView];
	
	self.scrollView.contentSize = image.size;
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	CGRect scrollViewFrame = self.scrollView.frame;
	NSLog(@"scrollViewFrame = %f, %f", scrollViewFrame.size.width, scrollViewFrame.size.height);
	CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
	NSLog(@"self.scrollView.contentSize. = %f, %f", self.scrollView.contentSize.width, self.scrollView.contentSize.height);
	CGFloat scaleHeight = scrollViewFrame.size.height/ self.scrollView.contentSize.height;
	CGFloat minScale = MIN(scaleWidth, scaleHeight);
	NSLog(@"scaleWidth = %f,scaleHeight =  %f", scaleWidth, scaleHeight);
	
	self.scrollView.minimumZoomScale = minScale;
	self.scrollView.maximumZoomScale = 1.0f;
	self.scrollView.zoomScale = minScale;
	
	[self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoggingCGSize:(CGSize)size withString:(NSString *)string{
	NSLog(@"%@.width = %f, %@.height = %f", string, size.width, string, size.height);
}

-(void)LoggingCGRect:(CGRect)rect withString:(NSString *)string{
	NSLog(@"%@ = (%f, %f, %f, %f)", string, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

-(void)centerScrollViewContents{
	CGSize boundSize = self.scrollView.bounds.size;
	CGRect contentsFrame = self.imageView.frame;
	
	[self LoggingCGSize:boundSize withString:@"boundSize"];
	[self LoggingCGRect:contentsFrame withString:@"contentFrame"];
	
	if (contentsFrame.size.width < boundSize.width) {
		contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width)/2.0f;
	}else{
		contentsFrame.origin.x = 0.0f;
	}
	
	if (contentsFrame.size.height < boundSize.height) {
		contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height)/2.0f;
	}else{
		contentsFrame.origin.y = 0.0f;
	}
	
	self.imageView.frame = contentsFrame;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[self centerScrollViewContents];
}


#pragma mark- UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
	[self centerScrollViewContents];
}

@end
