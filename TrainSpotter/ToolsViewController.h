//
//  ToolsViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 24/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface ToolsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *submitOpinionButton;
@property (weak, nonatomic) IBOutlet UIButton *checkWeatherButton;



@end
