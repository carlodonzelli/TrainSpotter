//
//  DelayViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "DelayViewController.h"

@interface DelayViewController ()

@end

@implementation DelayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *currentId = theAppDelegate.objectID;
    
    if (currentId != nil) {
        
        NSLog(@"objectID exist, time and distance enabled");
        
        [self.travelTimeButton setEnabled:YES];
        [self.travelDistanceButton setEnabled:YES];
    }
    else {
        NSLog(@"objectID not created");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)calculateTime:(id)sender {
    
    NSString *currentId = theAppDelegate.objectID;
    NSDate *currentDateTime = [NSDate date];
    // Instantiate a NSDateFormatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Set the dateFormatter format
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    // Get the date time in NSString
    NSString *currentFormattedTime = [dateFormatter stringFromDate:currentDateTime];
    NSLog(@"Current Time: %@", currentFormattedTime);
    
    PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
    [query getObjectInBackgroundWithId:currentId block:^(PFObject *tempObject, NSError *error) {
        NSDate *createdDateTime = tempObject.createdAt;
        NSString *createdFormattedTime = [dateFormatter stringFromDate:createdDateTime];
        NSLog(@"Created Time: %@", createdFormattedTime);
        //NSTimeInterval theTimeInterval = [currentDateTime timeIntervalSinceDate:createdDateTime];
        
        // Get the system calendar
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Get conversion to months, days, hours, minutes
        unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        
        NSDateComponents *conversionInfo = [sysCalendar components:unitFlags fromDate:createdDateTime  toDate:currentDateTime  options:0];
        
        NSLog(@"Time passed: %d second %d minute %d hour", [conversionInfo second], [conversionInfo minute], [conversionInfo hour]);
        
        NSString *timePassed = [NSString stringWithFormat:@"%d second %d minute %d hour", [conversionInfo second], [conversionInfo minute], [conversionInfo hour]];
        [[[UIAlertView alloc] initWithTitle:@"Elapsed Time"
                                    message:timePassed
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
    }];
}

- (IBAction)calculateDistance:(id)sender {
    
    NSString *currentId = theAppDelegate.objectID;
    
    //Create query for all Check In object by the current user
    PFQuery *postQuery = [PFQuery queryWithClassName:@"CheckIn"];
    //[postQuery whereKey:@"user" equalTo:[PFUser currentUser].username];
    [postQuery whereKey:@"objectId" equalTo:currentId];
    //[postQuery whereKeyExists:@"startPoint"];
    NSArray *queryObjects = [postQuery findObjects];
    PFObject *location = [queryObjects objectAtIndex:0];
    PFGeoPoint *startPoint = [location objectForKey:@"startPoint"];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            double distance = [startPoint distanceInKilometersTo:geoPoint];
            
            NSString *kmDistance = [NSString stringWithFormat: @"Travel Lenght: %f Km", distance];
            
            
            [[[UIAlertView alloc] initWithTitle:@"Distance"
                                        message:kmDistance
                                       delegate:nil
                              cancelButtonTitle:@"Dismiss"
                              otherButtonTitles:nil] show];
        }
    }];
    
    
    
    //running the query
    //    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
    //        if (!error) {
    //            //Save results and update the table
    //            NSLog(@"Successfully retrieved %d train.", objects.count);
    //
    //            for (PFObject *object in objects) {
    //                            NSLog(@"%@", object.objectId);
    //                        }
    //        } else {
    //            // Log details of the failure
    //            NSLog(@"Error: %@ %@", error, [error userInfo]);
    //        }
    //    }];
    
}
@end
