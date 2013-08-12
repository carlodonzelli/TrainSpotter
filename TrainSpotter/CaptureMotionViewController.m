//
//  CaptureMotionViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 24/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CaptureMotionViewController.h"

@interface CaptureMotionViewController ()

@end

@implementation CaptureMotionViewController

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
    //ACCELEROMETER
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
    if (motionManager.accelerometerAvailable) {
        NSLog(@"Accelerometer avaliable");
        queue = [NSOperationQueue currentQueue];
        [motionManager startAccelerometerUpdatesToQueue:queue
                                            withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                CMAcceleration acceleration = accelerometerData.acceleration;
                                                self.xLabel.text = [NSString stringWithFormat:@"%f", acceleration.x];
                                                self.xBar.progress = ABS(acceleration.x);
                                                self.yLabel.text = [NSString stringWithFormat:@"%f", acceleration.y];
                                                self.yBar.progress = ABS(acceleration.y);
                                                self.zLabel.text = [NSString stringWithFormat:@"%f", acceleration.z];
                                                self.zBar.progress = ABS(acceleration.z);
                                            }];
    }
    
    //GYROSCOPE
    //motionManager = [[CMMotionManager alloc] init];
    motionManager.gyroUpdateInterval = 1.0/10.0; // Update every 1/2 second.
    if (motionManager.gyroAvailable) {
        queue = [NSOperationQueue currentQueue];
        [motionManager startGyroUpdatesToQueue:queue
                                   withHandler: ^ (CMGyroData *gyroData, NSError *error) {
                                       CMRotationRate rotate = gyroData.rotationRate;
                                       _xGLabel.text = [NSString stringWithFormat:@"%f", rotate.x];
                                       _xGBar.progress = ABS(rotate.x);
                                       _yGLabel.text = [NSString stringWithFormat:@"%f", rotate.y];
                                       _yGBar.progress = ABS(rotate.y);
                                       _zGLabel.text = [NSString stringWithFormat:@"%f", rotate.z];
                                       _zGBar.progress = ABS(rotate.z);
                                   }]; }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
