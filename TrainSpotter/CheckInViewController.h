//
//  CheckInViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 15/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface CheckInViewController : UIViewController

@property (weak, nonatomic) IBOutlet MBProgressHUD *HUD;

@property (weak, nonatomic) IBOutlet UILabel *loggedUser;

@property (weak, nonatomic) IBOutlet UITextField *trainNumber;
@property (weak, nonatomic) IBOutlet UITextField *departureStation;
@property (weak, nonatomic) IBOutlet UITextField *arrivalStation;

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (IBAction)doCheckIn:(id)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)logout:(id)sender;

@end
