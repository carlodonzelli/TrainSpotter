//
//  ToolsViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 24/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ToolsViewController.h"

@interface ToolsViewController ()

@end

@implementation ToolsViewController

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
    
    //simple check to enable "submit opinion" and "check weather" only if the user did a check-in
    if (currentId != nil) {
        
        NSLog(@"objectID exist, opinion and check weather enabled");
        
        [self.submitOpinionButton setEnabled:YES];
        [self.checkWeatherButton setEnabled:YES];
    }
    else {
        NSLog(@"objectID not created");
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    //[self.navigationItem setHidesBackButton:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
