//
//  CaptureMotionViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 24/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface CaptureMotionViewController : ViewController {
    
    CMMotionManager *motionManager;
    NSOperation *queue;
}

@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *xBar;
@property (weak, nonatomic) IBOutlet UIProgressView *yBar;
@property (weak, nonatomic) IBOutlet UIProgressView *zBar;

@property (weak, nonatomic) IBOutlet UILabel *xGLabel;
@property (weak, nonatomic) IBOutlet UILabel *yGLabel;
@property (weak, nonatomic) IBOutlet UILabel *zGLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *xGBar;
@property (weak, nonatomic) IBOutlet UIProgressView *yGBar;
@property (weak, nonatomic) IBOutlet UIProgressView *zGBar;

@end
