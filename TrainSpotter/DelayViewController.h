//
//  DelayViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface DelayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *travelDistanceButton;
@property (weak, nonatomic) IBOutlet UIButton *travelTimeButton;

- (IBAction)calculateTime:(id)sender;
- (IBAction)calculateDistance:(id)sender;

@end
