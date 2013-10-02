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

@interface RecentViewPhotoesTableViewController ()

@property (nonatomic, strong) NSArray *recentViewedPhotoes;

@end

@implementation RecentViewPhotoesTableViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	NSDictionary *selectedPhotoInfo = [self.recentViewedPhotoes objectAtIndex:indexPath.row];
	PhotoViewController	*photoViewController = segue.destinationViewController;
	photoViewController.photoURL = [FlickrFetcher urlForPhoto:selectedPhotoInfo format:FlickrPhotoFormatLarge];

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
}

-(void)viewWillAppear:(BOOL)animated{
	self.recentViewedPhotoes = [[NSUserDefaults standardUserDefaults] objectForKey:FLICKR_RECENT_VIEW_PHOTO_KEY];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.recentViewedPhotoes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent View Photoes Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
	NSLog(@"recentViewedPhotoes = %@", [self.recentViewedPhotoes description]);
	NSDictionary *recentViewedPhotoData = self.recentViewedPhotoes[indexPath.row];
	
	NSString *photoTitle = [recentViewedPhotoData valueForKey:FLICKR_PHOTO_TITLE];
	NSString *photoDescription = [recentViewedPhotoData valueForKey:FLICKR_PHOTO_DESCRIPTION];
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
