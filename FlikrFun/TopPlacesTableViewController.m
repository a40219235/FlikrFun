//
//  TopPlacesTableViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/26/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "PlacePhotoesTableViewController.h"
#import "MapKitViewController.h"
#import "FlikrerPhotoAnnotation.h"
#import "PhotoViewController.h"
#import "TableViewUtility.h"

@interface TopPlacesTableViewController () <MapKitViewControllerDelegate>

@property(nonatomic, strong) NSArray *topPlaces;

@end

@implementation TopPlacesTableViewController
@synthesize topPlaces = _topPlaces;

#pragma mark - setters and getters
-(void)setTopPlaces:(NSArray *)topPlaces{
	if (![_topPlaces isEqualToArray:topPlaces]){
		_topPlaces = topPlaces;
		// as long as self is on the stack, reload it
		if (self) {
//			NSLog(@"topViewController = %@", [[self.navigationController topViewController] class]);
			[self.tableView reloadData];
		}
		
		//if present scene is map kit view controller, update annotations
		if ([[[self.navigationController topViewController] class] isEqual:[MapKitViewController class]]) {
//			NSLog(@"topViewController = %@", [[self.navigationController topViewController] class]);
			MapKitViewController *mapKitController = (MapKitViewController *)[self.navigationController topViewController];
			mapKitController.annotations = [self mapAnnotations];
		}
	}
}

#pragma mark - segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"Place Photoes Sague"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *selectedPlaceInfo = [self.topPlaces objectAtIndex:indexPath.row];
		NSLog(@"selectedPlaceInfo = %@", selectedPlaceInfo);
		PlacePhotoesTableViewController *placePhotoesTVC = segue.destinationViewController;
		placePhotoesTVC.placeInfo = selectedPlaceInfo;
		
		//change the backButton's title
		UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[selectedPlaceInfo valueForKey:FLICKR_WOE_NAME] style:UIBarButtonItemStylePlain target:nil action:nil];
		self.navigationItem.backBarButtonItem = backButton;
	}
	
	if([segue.identifier isEqualToString:@"Map Kit View Segue"]){
		MapKitViewController *mapKitViewController = segue.destinationViewController;
		mapKitViewController.annotations = [self mapAnnotations];
		mapKitViewController.delegate = self;
//		NSLog(@"photoes send  = %@", mapKitViewController.annotations);
	}
}

-(NSArray *)mapAnnotations{
	NSMutableArray *annotations = [[NSMutableArray alloc] init];
	for (NSDictionary *places in self.topPlaces) {
		[annotations addObject:[FlikrerPhotoAnnotation annotationForPhotoes:places]];
	}
	return annotations;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.	
}

#pragma mark - buttons pressed handler
-(void)refreshPressed:(UIBarButtonItem *)sender {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	
	__block NSArray * topPlacesData;
	[TableViewUtility loadDataUsingBlock:^{
		topPlacesData = [FlickrFetcher topPlaces];
	}InQueue:nil withComplitionHandler:^{
		self.topPlaces = topPlacesData;
//		NSLog(@"topPlaces = %@", [self.topPlaces description]);
		self.navigationItem.rightBarButtonItem = sender;
	}];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	NSDictionary *placeDetails= [self.topPlaces objectAtIndex:indexPath.row];
	cell.textLabel.text = [placeDetails valueForKey:FLICKR_WOE_NAME];
	cell.detailTextLabel.text = [placeDetails valueForKey:FLICKR_PLACE_NAME];
    
    return cell;
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

#pragma mark - MapKitViewControllerDelegate
-(UIImage *)MapKitViewController:(MapKitViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation{
	FlikrerPhotoAnnotation *fpa = (FlikrerPhotoAnnotation *)annotation;
	NSURL *url = [FlickrFetcher urlForPhoto:fpa.photoes format:FlickrPhotoFormatSquare];
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	return data ? [UIImage imageWithData:data] : nil;
}

-(void)MapKitViewController:(MapKitViewController *)sender annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
	//if there is photo, navigate to show the photo instead, else zoom to show the current place
	FlikrerPhotoAnnotation * anotation = (FlikrerPhotoAnnotation *)view.annotation;
	NSURL *url = [FlickrFetcher urlForPhoto:anotation.photoes format:FlickrPhotoFormatLarge];
	if (url) {
		UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
		PhotoViewController *photoViewController = [sb instantiateViewControllerWithIdentifier:@"Photo View Controller"];
		photoViewController.photoURL = url;
		[self.navigationController pushViewController:photoViewController animated:YES];
		return;
	}
	
	//replace the accessory to spinner to avoid multiple clicks, and don't worry about reset back to uibutton, cause it will get removed and added back
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[spinner startAnimating];
	view.rightCalloutAccessoryView = nil;
	view.rightCalloutAccessoryView = spinner;
	
	CLLocationCoordinate2D center = [view.annotation coordinate];
	__block NSArray *photoesOfPlace;
	[TableViewUtility loadDataUsingBlock:^{
		photoesOfPlace = [FlickrFetcher photosInPlace:anotation.photoes maxResults:50];
	}InQueue:nil withComplitionHandler:^{
		//do nothing if current viewController isn't MapKitViewController
		if ([[[self.navigationController topViewController] class] isEqual:[MapKitViewController class]]) {
			NSMutableArray *annotations = [[NSMutableArray alloc] init];
			for (NSDictionary *places in photoesOfPlace) {
				[annotations addObject:[FlikrerPhotoAnnotation annotationForPhotoes:places]];
			}
			MapKitViewController *mapKitController = (MapKitViewController *)[self.navigationController topViewController];
			mapKitController.annotations = annotations;
			
			//zoom the map to location
			MKCoordinateSpan span = MKCoordinateSpanMake(10, 10);
			MKCoordinateRegion regionToDisplay = MKCoordinateRegionMake(center, span);
			[mapKitController.mapView setRegion:regionToDisplay animated:YES];
		}
	}];
}
@end
