//
//  RecentViewPhotoesTableViewController.m
//  FlikrFun
//
//  Created by Shane Fu on 9/26/13.
//  Copyright (c) 2013 Shane Fu. All rights reserved.
//

#import "RecentViewPhotoesTableViewController.h"
#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "UIManagedDocument+Manager.h"
#import "Photo+Create.h"

@interface RecentViewPhotoesTableViewController ()

@property (nonatomic, strong) NSArray *recentViewedPhotoes;

@end

@implementation RecentViewPhotoesTableViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	PhotoViewController	*photoViewController = segue.destinationViewController;
	Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
	photoViewController.photoURL = [NSURL URLWithString:photo.imageURL];
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

-(void)loadDataFromFile{
	[UIManagedDocument openDefaultManagedDocumentWithCompletionHandler:^(BOOL success) {
		if (success) {
			[self setupFetchedResultsController];
		}
	}];
}

-(void)setupFetchedResultsController{
	NSManagedObjectContext *defaultContext = [UIManagedDocument defaultManagedDocument].managedObjectContext;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
	request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"dateViewing" ascending:NO]];
	
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:defaultContext sectionNameKeyPath:nil cacheName:nil];
}


-(void)viewWillAppear:(BOOL)animated{
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent View Photoes Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = photo.title;
	cell.detailTextLabel.text = photo.subtitle;
	
    return cell;
}

@end
