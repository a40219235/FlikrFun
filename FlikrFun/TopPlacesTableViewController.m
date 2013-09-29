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

@interface TopPlacesTableViewController ()

@property(nonatomic, strong) NSArray *topPlaces;

@end

@implementation TopPlacesTableViewController
@synthesize topPlaces = _topPlaces;

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	if ([segue.identifier isEqualToString:@"Place Photoes Sague"]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		NSDictionary *selectedPlaceInfo = [self.topPlaces objectAtIndex:indexPath.row];
//		NSLog(@"selectedPlaceInfo = %@", selectedPlaceInfo);
		PlacePhotoesTableViewController *placePhotoesTVC = segue.destinationViewController;
		placePhotoesTVC.placeInfo = selectedPlaceInfo;
	}
	
	if([segue.identifier isEqualToString:@"Map Kit View Segue"]){
		MapKitViewController *mapKitViewController = segue.destinationViewController;
		mapKitViewController.annotations = [self mapAnnotations];
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

#pragma mark - queue
-(void)downloadDataWithCompletionHandler:(void(^)(void))completionHandler{
	dispatch_queue_t downloadImageQueue	= dispatch_queue_create("download data queue", NULL);
	dispatch_async(downloadImageQueue, ^{
		NSArray *topPlacesData = [FlickrFetcher topPlaces];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.topPlaces = topPlacesData;
			NSLog(@"topPlaces = %@", [self.topPlaces description]);
			if (completionHandler) {
				completionHandler();
			}
		});
	});
}

#pragma mark - buttons pressed handler
-(void)refreshPressed:(UIBarButtonItem *)sender {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[spinner startAnimating];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
	[self downloadDataWithCompletionHandler:^{
		self.navigationItem.rightBarButtonItem = sender;
	}];
	
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	return 3;
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}
@end
