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
#define RECENT_VIEW_PHOTO_KEY @"recent_view_photo_key"
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
	self.recentViewedPhotoes = [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_VIEW_PHOTO_KEY];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
