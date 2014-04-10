//
//  ProfileViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    NSString *userName = [NSString stringWithFormat:@"%@", [PFUser currentUser].username];
    self.loggedUserLabel.text = userName;
    
    PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
    [query whereKey:@"user" equalTo:userName];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            // The count request succeeded. Log the count
            NSLog(@"Current user has done %d check-ins", count);
            self.numCheckIn.text = [NSString stringWithFormat:@"%d", count];
        } else {
            NSLog(@"Count object request failed: %@", error);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
