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

@interface PlacePhotoesTableViewController () <MapKitViewControllerDelegate>

@property (nonatomic, strong) NSArray *photoesOfPlace;

@end

#define RECENT_VIEW_PHOTO_KEY @"recent_view_photo_key"

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
		NSDictionary *selectedPhotoInfo = [self.photoesOfPlace objectAtIndex:indexPath.row];
		PhotoViewController	*photoViewController = segue.destinationViewController;
		photoViewController.photoURL = [FlickrFetcher urlForPhoto:selectedPhotoInfo format:FlickrPhotoFormatLarge];
	}
	
	if ([segue.identifier isEqualToString:@"Map Kit View Segue"]) {
		MapKitViewController *mapKitViewController = segue.destinationViewController;
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
	[self loadPhotoesWithCompletionHandler:^{
		self.navigationItem.rightBarButtonItem = sender;
	}];
}

-(void)loadPhotoesWithCompletionHandler:(void(^)(void))completionHandler{
	dispatch_queue_t downloadPhotoQueue	= dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
	dispatch_async(downloadPhotoQueue, ^{
		NSArray *photoesOfPlace = [FlickrFetcher photosInPlace:self.placeInfo maxResults:50];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.photoesOfPlace = photoesOfPlace;
			if (completionHandler) completionHandler();
				NSLog(@"self.placeInfo = %@", self.placeInfo);
				NSLog(@"self.photoesOfPlace = %@", [self.photoesOfPlace description]);
		});
	});
}

#pragma mark - buttons pressed handler


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
	NSString *photoDescription = [self.photoesOfPlace[indexPath.row] valueForKey:FLICKR_PHOTO_DESCRIPTION];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *selectedPhoto = [self.photoesOfPlace objectAtIndex:indexPath.row];
	NSMutableArray *recentViewPhotoes = [[[NSUserDefaults standardUserDefaults] objectForKey:RECENT_VIEW_PHOTO_KEY] mutableCopy];
	if (!recentViewPhotoes) {
		recentViewPhotoes = [NSMutableArray array];
	}
	[recentViewPhotoes addObject:selectedPhoto];
	[[NSUserDefaults standardUserDefaults] setObject:recentViewPhotoes forKey:RECENT_VIEW_PHOTO_KEY];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - MapKitViewControllerDelegate
-(UIImage *)MapKitViewController:(MapKitViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation{
	FlikrerPhotoAnnotation *fpa = (FlikrerPhotoAnnotation *)annotation;
	NSURL *url = [FlickrFetcher urlForPhoto:fpa.photoes format:FlickrPhotoFormatSquare];
	NSData *data = [NSData dataWithContentsOfURL:url];
	
	return data ? [UIImage imageWithData:data] : nil;
}

@end
