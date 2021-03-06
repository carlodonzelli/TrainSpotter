//
//  DeviceMotionDataViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 31/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "DeviceMotionDataViewController.h"

@interface DeviceMotionDataViewController ()

@end

@implementation DeviceMotionDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(CMMotionManager *)motionManager
{
    // Lazy initialization
    if (_motionManager == nil)
    {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startUpdates:(id)sender {
    
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    
    // Start device motion updates
    if ([self.motionManager isDeviceMotionAvailable])
    {
        //Update twice per second
        [self.motionManager setDeviceMotionUpdateInterval:1.0/2.0];
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:
         CMAttitudeReferenceFrameXMagneticNorthZVertical
                                                                toQueue:[NSOperationQueue mainQueue]
                                                            withHandler:
         ^(CMDeviceMotion *deviceMotion, NSError *error)
         {
             // Update attitude labels
             self.rollLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.attitude.roll];
             self.pitchLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.attitude.pitch];
             self.yawLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.attitude.yaw];
             
             // Update rotation rate labels
             self.xRotLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.rotationRate.x];
             self.yRotLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.rotationRate.y];
             self.zRotLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.rotationRate.z];
             
             // Update user acceleration labels
             self.xGravLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.gravity.x];
             self.yGravLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.gravity.y];
             self.zGravLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.gravity.z];
             
             // Update user acceleration labels
             self.xAccLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.userAcceleration.x];
             self.yAccLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.userAcceleration.y];
             self.zAccLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.userAcceleration.z];
             
             // Update magnetic field labels
             self.xMagLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.magneticField.field.x];
             self.yMagLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.magneticField.field.y];
             self.zMagLabel.text = [NSString stringWithFormat:@"%f", deviceMotion.magneticField.field.z];
         }];
    }

}

- (IBAction)stopUpdates:(id)sender {
    
    [self.startButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
    
    if ([self.motionManager isDeviceMotionAvailable] && [self.motionManager isDeviceMotionActive])
    {
        [self.motionManager stopDeviceMotionUpdates];  
    }
}
@end
