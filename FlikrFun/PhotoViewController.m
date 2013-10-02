 //
//  PhotoViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/27/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "PhotoViewController.h"
#import "TableViewUtility.h"

@interface PhotoViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView * spinner;

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
	
	//set spinner position here cause scrollView is inited here
	self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.spinner startAnimating];
	[self.view addSubview:self.spinner];
	
	__block NSData *imageData;
	PhotoViewController __weak *weakSelf = self;
	
	[TableViewUtility loadDataUsingBlock:^{
		imageData = [NSData dataWithContentsOfURL:self.photoURL];
	}InQueue:nil withComplitionHandler:^{
		[self.spinner removeFromSuperview];
		self.spinner = NULL;
		
		UIImage *image = [UIImage imageWithData:imageData];
		self.imageView = [[UIImageView alloc] initWithImage:image];
		self.imageView.frame = CGRectMake(0,0,image.size.width, image.size.height);
		[self.scrollView addSubview:self.imageView];
		self.scrollView.contentSize = image.size;
		
		CGRect scrollViewFrame = self.scrollView.frame;
		CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
		CGFloat scaleHeight = scrollViewFrame.size.height/ self.scrollView.contentSize.height;
		CGFloat minScale = MIN(scaleWidth, scaleHeight);
		
		self.scrollView.minimumZoomScale = minScale;
		self.scrollView.maximumZoomScale = 1.0f;
		self.scrollView.zoomScale = minScale;
		
		[weakSelf centerScrollViewContents];
	}];
}

-(void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	if (self.spinner) {
		self.spinner.center = self.scrollView.center;
	}
}

-(void)viewWillDisappear:(BOOL)animated{
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centerScrollViewContents{
	CGSize boundSize = self.scrollView.bounds.size;
	CGRect contentsFrame = self.imageView.frame;
	
//	[TableViewUtility LoggingCGSize:boundSize withString:@"boundSize"];
//	[TableViewUtility LoggingCGRect:contentsFrame withString:@"contentFrame"];
	
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
