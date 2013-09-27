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

@interface PlacePhotoesTableViewController ()

@property (nonatomic, strong) NSArray *photoesOfPlace;
@end

#define RECENT_VIEW_PHOTO_KEY @"recent_view_photo_key"

@implementation PlacePhotoesTableViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
	
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	NSDictionary *selectedPhotoInfo = [self.photoesOfPlace objectAtIndex:indexPath.row];
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
	
	self.photoesOfPlace = [FlickrFetcher photosInPlace:self.placeInfo maxResults:2];
	NSLog(@"self.photoesOfPlace = %@", [self.photoesOfPlace description]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
	NSString *photoTitle = [self.photoesOfPlace[indexPath.row] valueForKey:@"title"];
	NSString *photoDescription = [self.photoesOfPlace[indexPath.row] valueForKey:@"description._content"];
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

@end
