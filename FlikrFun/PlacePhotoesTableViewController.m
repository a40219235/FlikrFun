//
//  PlacePhotoesTableViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/26/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "PlacePhotoesTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "MapKitViewController.h"
#import "FlikrerPhotoAnnotation.h"
#import "TableViewUtility.h"

@interface PlacePhotoesTableViewController () <MapKitViewControllerDelegate>

@property (nonatomic, strong) NSArray *photoesOfPlace;

@end

@implementation PlacePhotoesTableViewController
@synthesize photoesOfPlace = _photoesOfPlace;

#pragma mark - setters and getters
-(void)setPhotoesOfPlace:(NSArray *)photoesOfPlace{
	if (_photoesOfPlace != photoesOfPlace) {
		_photoesOfPlace = photoesOfPlace;
		//only reload the table if we are on the current table scene
		if (self) {
			[self.tableView reloadData];
		}
		
		//if present scene is map kit view controller, update annotations
		if ([[[self.navigationController topViewController] class] isEqual:[MapKitViewController class]]) {
			MapKitViewController *mapKitController = (MapKitViewController *)[self.navigationController topViewController];
			mapKitController.annotations = [self mapAnnotations];
		}
	}
}

-(NSArray *)mapAnnotations{
	NSMutableArray *annotations = [[NSMutableArray alloc] init];
	[self.photoesOfPlace enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSDictionary *dictObj = (NSDictionary *)obj;
		[annotations addObject:[FlikrerPhotoAnnotation annotationForPhotoes:dictObj]];
	}];
	 return annotations;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"Photo View Segue"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
		NSDictionary *selectedPhotoInfo = [self.photoesOfPlace objectAtIndex:indexPath.row];
		PhotoViewController	*photoViewController = segue.destinationViewController;
		photoViewController.photoURL = [FlickrFetcher urlForPhoto:selectedPhotoInfo format:FlickrPhotoFormatLarge];
		NSLog(@"cell.textLabel.text = %@", cell.textLabel.text);
		photoViewController.imageTitle = cell.textLabel.text;
		photoViewController.imageSubtitle = cell.detailTextLabel.text;
		
	}
	
	if ([segue.identifier isEqualToString:@"Map Kit View Segue"]) {
		MapKitViewController *mapKitViewController = segue.destinationViewController;
		
		//zoom the map to location
		MKCoordinateSpan span = MKCoordinateSpanMake(10, 10);
		CLLocationCoordinate2D center = CLLocationCoordinate2DMake([[self.placeInfo objectForKey:FLICKR_LATITUDE] doubleValue], [[self.placeInfo objectForKey:FLICKR_LONGITUDE] doubleValue]);

		mapKitViewController.shouldZoomAfterLoading = YES;
		mapKitViewController.center = center;
		mapKitViewController.span = span;
		
		mapKitViewController.annotations = [self mapAnnotations];
		mapKitViewController.delegate = self;
	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshPressed:)];
	[self refreshPressed:self.navigationItem.rightBarButtonItem];
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)refreshPressed:(id)sender {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
	__block NSArray *photoesOfPlace;
	[TableViewUtility loadDataUsingBlock:^{
		photoesOfPlace = [FlickrFetcher photosInPlace:self.placeInfo maxResults:50];
	}InQueue:nil withComplitionHandler:^{
		self.photoesOfPlace = photoesOfPlace;
		self.navigationItem.rightBarButtonItem = sender;
		//NSLog(@"self.placeInfo = %@", self.placeInfo);
		//NSLog(@"self.photoesOfPlace = %@", [self.photoesOfPlace description]);
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photoesOfPlace count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photoes Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSString *photoTitle = [self.photoesOfPlace[indexPath.row] valueForKey:FLICKR_PHOTO_TITLE];
	NSString *photoDescription = [self.photoesOfPlace[indexPath.row] valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
	if ([photoTitle length] >0) {
		cell.textLabel.text = photoTitle;
		cell.detailTextLabel.text = photoDescription;
	}else if([photoDescription length] >0){
		cell.textLabel.text = photoDescription;
	}else{
		cell.textLabel.text = @"Unknown";
	}
	
    return cell;
}

//#pragma mark - Table view delegate

#pragma mark - MapKitViewControllerDelegate
-(UIImage *)MapKitViewController:(MapKitViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation{
	if ([annotation class] != [FlikrerPhotoAnnotation class]) {
		return nil;
	}
	FlikrerPhotoAnnotation *fpa = (FlikrerPhotoAnnotation *)annotation;
	NSURL *url = [FlickrFetcher urlForPhoto:fpa.photoes format:FlickrPhotoFormatSquare];
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	return data ? [UIImage imageWithData:data] : nil;
}

-(void)MapKitViewController:(MapKitViewController *)sender annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	if ([view.annotation class] != [FlikrerPhotoAnnotation class]) {
		return;
	}
	
	FlikrerPhotoAnnotation * anotation = (FlikrerPhotoAnnotation *)view.annotation;
	NSLog(@"anotation.photoes = %@", anotation.photoes);
	NSURL *url = [FlickrFetcher urlForPhoto:anotation.photoes format:FlickrPhotoFormatLarge];
	NSLog(@"url = %@", url);
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
	PhotoViewController *photoViewController = [sb instantiateViewControllerWithIdentifier:@"Photo View Controller"];
	photoViewController.photoURL = url;
	photoViewController.imageTitle = anotation.title;
	photoViewController.imageSubtitle = anotation.subtitle;
	[self.navigationController pushViewController:photoViewController animated:YES];
}

@end
