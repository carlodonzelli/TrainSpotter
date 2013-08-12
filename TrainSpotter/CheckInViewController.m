//
//  CheckInViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 15/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CheckInViewController.h"

@interface CheckInViewController ()

@end

@implementation CheckInViewController

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
    _loggedUser.text = [PFUser currentUser].username;
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(329, 600)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doCheckIn:(id)sender {
    
    PFUser *user = [PFUser currentUser];
    
    NSString *trainNum = [NSString stringWithFormat: @"%@", _trainNumber.text];
    NSString *depStation = [NSString stringWithFormat: @"%@", _departureStation.text];
    NSString *arrStation = [NSString stringWithFormat: @"%@", _arrivalStation.text];
    
    PFObject *checkIn = [PFObject objectWithClassName:@"CheckIn"];
    [checkIn setObject:trainNum forKey:@"trainNumber"];
    [checkIn setObject:depStation forKey:@"departureStation"];
    [checkIn setObject:arrStation forKey:@"arrivalStation"];
    [checkIn setObject:user forKey:@"user"];
    [checkIn save];
    
    
    NSLog(@"%@, %@, %@", trainNum, depStation, arrStation);
    
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)backgroundTap:(id)sender {
    [self.trainNumber resignFirstResponder];
    [self.departureStation resignFirstResponder];
    [self.arrivalStation resignFirstResponder];
}

- (IBAction)logout:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Logout"
                                message:@"Are you sure you want to logout?"
                               delegate:self
                      cancelButtonTitle:@"No" 
                      otherButtonTitles:@"Yes", nil] show];
}

//UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        //if user clic yes (wants to logout)
        if (buttonIndex == 1) {
            [PFUser logOut];
            NSLog(@"Logged Out");
            [self performSegueWithIdentifier:@"fromCheckInToHome" sender:self];
        }
}

@end
