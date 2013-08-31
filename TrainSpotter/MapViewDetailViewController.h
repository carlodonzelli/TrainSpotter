//
//  MapViewDetailViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 29/08/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MapViewViewController.h"

@interface MapViewDetailViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;

@property (weak, nonatomic) NSString *time;
@property (weak, nonatomic) NSString *latitude;
@property (weak, nonatomic) NSString *longitude;
@property (weak, nonatomic) NSString *speed;
@property (weak, nonatomic) NSString *altitiude;
@property (weak, nonatomic) NSString *course;
@property (weak, nonatomic) NSString *horizontalAcc;
@property (weak, nonatomic) NSString *verticalAcc;



@end
