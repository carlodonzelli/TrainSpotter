//
//  DeviceMotionDataViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 31/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//
/*
 The attitude property is an instance of the CMAttitude class. It gives you a detailed insight into the device’s orientation at a given time as compared to a reference frame. Through this class you can access properties such as roll, pitch, and yaw. These values are measured in radians and allow you an accurate measurement of your device’s orientation.
 -As shown previously in Figure 5-4, roll specifies the device’s position of rotation around the y-axis, pitch the position of rotation around the x-axis, and yaw around the z-axis.
 -The rotationRate property is just like the one you saw in the previous recipe, except that it gives a more accurate reading. It does this by reducing device bias that causes a still device to have nonzero rotation values.
 -The gravity property represents the acceleration caused solely by gravity on the device.
 -The userAcceleration represents the physical acceleration imparted on a device by the user outside gravitational acceleration.
 -The magneticField value is similar to the one you saw in Recipe 5-2; however, it removes any device bias, resulting in more accurate readings.
 */

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface DeviceMotionDataViewController : ViewController

@property (strong, nonatomic) IBOutlet UILabel *rollLabel;
@property (strong, nonatomic) IBOutlet UILabel *pitchLabel;
@property (strong, nonatomic) IBOutlet UILabel *yawLabel;
@property (strong, nonatomic) IBOutlet UILabel *xRotLabel;
@property (strong, nonatomic) IBOutlet UILabel *yRotLabel;
@property (strong, nonatomic) IBOutlet UILabel *zRotLabel;
@property (strong, nonatomic) IBOutlet UILabel *xGravLabel;
@property (strong, nonatomic) IBOutlet UILabel *yGravLabel;
@property (strong, nonatomic) IBOutlet UILabel *zGravLabel;
@property (strong, nonatomic) IBOutlet UILabel *xAccLabel;
@property (strong, nonatomic) IBOutlet UILabel *yAccLabel;
@property (strong, nonatomic) IBOutlet UILabel *zAccLabel;
@property (strong, nonatomic) IBOutlet UILabel *xMagLabel;
@property (strong, nonatomic) IBOutlet UILabel *yMagLabel;
@property (strong, nonatomic) IBOutlet UILabel *zMagLabel;

@property (nonatomic, strong) CMMotionManager *motionManager;

- (IBAction)startUpdates:(id)sender;
- (IBAction)stopUpdates:(id)sender;


@end
