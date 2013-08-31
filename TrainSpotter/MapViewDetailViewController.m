//
//  MapViewDetailViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 29/08/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "MapViewDetailViewController.h"

@interface MapViewDetailViewController ()

@end

@implementation MapViewDetailViewController

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
    [_timeLabel setText:_time];
    [_latitudeLabel setText:_latitude];
    [_longitudeLabel setText:_longitude];
    [_speedLabel setText:_speed];
    [_altitudeLabel setText:_altitiude];
    [_courseLabel setText:_course];
    [_horizontalAccuracyLabel setText:_horizontalAcc];
    [_verticalAccuracyLabel setText:_verticalAcc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
