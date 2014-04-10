//
//  ReportTableViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 05/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ReportTableViewController.h"
#import "ReportTableViewCell.h"
#import "ReportDetailViewController.h"
#import <Parse/Parse.h>

@interface ReportTableViewController () {
    
    NSString *trainNumb;
    NSString *depStat;
    NSString *arrStat;
    NSString *cleanVal;
    NSString *stinkVal;
    NSString *crowdVal;
    NSString *qualityVal;
    NSString *noiseVal;
    NSString *comment;
    UIImage *image;
    
}

@end


@implementation ReportTableViewController


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
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    //setting title
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Pull to Refresh"];
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    // Configure View Controller
    [self setRefreshControl:refreshControl];
    
    
    //Create query for all Check In object by the current user
    PFQuery *postQuery = [PFQuery queryWithClassName:@"CheckIn"];
    [postQuery whereKey:@"user" equalTo:[PFUser currentUser].username];
    
    //running the query
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            //Save results and update the table
            _dataSourceArray = objects;
            [self.tableView reloadData];
            NSLog(@"Successfully retrieved %d train.", objects.count);
            // Do something with the found objects
            //            for (PFObject *object in objects) {
            //                NSLog(@"%@", object.objectId);
            //            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//implementing pull to refresh the table view
- (void)refresh:(UIRefreshControl *)sender {
    
    //set the title while refreshing
    sender.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    //last refresh update
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    sender.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    NSLog(@"Refreshing Table View");
    // End Refreshing
    [self.tableView reloadData];
    [sender endRefreshing];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"reportTableCell";
    
    ReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ReportTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //creatin a parse object for each row of the table
    PFObject *checkin = [_dataSourceArray objectAtIndex:indexPath.row];
    
    //setting labels name
    [cell.trainNumber setText:[checkin objectForKey:@"trainNumber"]];
    [cell.departureStation setText:[checkin objectForKey:@"departureStation"]];
    [cell.arrivalStation setText:[checkin objectForKey:@"arrivalStation"]];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    NSLog(@"Row %d selected", indexPath.row);
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Accessory disclosure %d selected", indexPath.row);
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"%@ segue pressed", segue.identifier);
    
    if ([segue.identifier isEqualToString:@"detailViewIdentifier"]) {
        
        PFObject *checkin = [_dataSourceArray objectAtIndex:[self.tableView indexPathForCell:sender].row];
        NSLog(@"1 - created checking");
        ReportDetailViewController *reportDetailViewController = (ReportDetailViewController *)segue.destinationViewController;
        NSLog(@"2 - created detalil view controller");
        trainNumb = [checkin objectForKey:@"trainNumber"];
        depStat = [checkin objectForKey:@"departureStation"];
        arrStat = [checkin objectForKey:@"arrivalStation"];
        cleanVal = [checkin objectForKey:@"cleaningValue"];
        stinkVal = [checkin objectForKey:@"stinkValue"];
        crowdVal = [checkin objectForKey:@"crowdingValue"];
        qualityVal = [checkin objectForKey:@"qualityValue"];
        noiseVal = [checkin objectForKey:@"avgNoiseLevel"];
        comment = [checkin objectForKey:@"userComment"];
        NSLog(@"3 - data retrieved");
        
        reportDetailViewController.trainNumber = trainNumb;
        reportDetailViewController.departStation = depStat;
        reportDetailViewController.arrivStation = arrStat;
        reportDetailViewController.cleaningValue = cleanVal;
        reportDetailViewController.stinkValue = stinkVal;
        reportDetailViewController.crowdingValue = crowdVal;
        reportDetailViewController.qualityValue = qualityVal;
        reportDetailViewController.noiseLevel = noiseVal;
        reportDetailViewController.commentValue = comment;
        NSLog(@"4 - data passed");
        
        PFFile *userImageFile = checkin[@"userImage"];
        NSData *imageData = [userImageFile getData];
        image = [UIImage imageWithData:imageData];
        NSLog(@"5 - userImage retrieved!");
        reportDetailViewController.userImage = image;
        
        
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            
//            if (!error) {
//                
//                image = [UIImage imageWithData:imageData];
//                reportDetailViewController.userImage = image;
//                NSLog(@"userImage retrieved!");
//                
//            }
//            else {
//                NSLog(@"Error while getting image");
//            }
//        }];
    } else {
        NSLog(@"Segue identifier not recognized");
    }
}



//method to pass data from this view to the comment view

@end
