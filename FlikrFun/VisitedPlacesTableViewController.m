//
//  VisitedPlacesTableViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/30/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "VisitedPlacesTableViewController.h"
#import "UIManagedDocument+Manager.h"
#import "TableViewUtility.h"
#import "FlickrFetcher.h"
#import "TopPlace+create.h"




@interface VisitedPlacesTableViewController ()

@end

@implementation VisitedPlacesTableViewController

#pragma mark - setters and getters

-(void)setupFetchedResultsController{
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TopPlace"];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"placeName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[UIManagedDocument defaultManagedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

-(void)fetchFlickkrDataIntoDocument{
	__block NSArray *topPlacesData;
	[TableViewUtility loadDataUsingBlock:^{
		topPlacesData = [FlickrFetcher topPlaces];
		NSLog(@"topPlacesData = %@", topPlacesData);
	} InQueue:nil withComplitionHandler:^{
		for (NSDictionary *flickrInfo in topPlacesData){
			[TopPlace createTopPlaceWithFlickrInfo:flickrInfo inManagedObjectContext:nil];
		}
		
		[[UIManagedDocument defaultManagedDocument] saveToURL:[UIManagedDocument defaultManagedDocument].fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
			NSAssert(success, @"save fails");
		}];
	}];
	
}

-(void)loadDataFromFile{
	[UIManagedDocument openDefaultManagedDocumentWithCompletionHandler:^(BOOL sucess) {
		NSLog(@"sucess = %d", sucess);
		if (sucess) {
			[self setupFetchedResultsController];
			[self fetchFlickkrDataIntoDocument];
		}
	}];
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
	
	[self loadDataFromFile];
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VisitedPlaceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    TopPlace *topPlace = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = topPlace.woeName;
	cell.detailTextLabel.text = topPlace.placeName;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
