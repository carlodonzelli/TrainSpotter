//
//  CheckWeatherViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 22/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherForecast.h"
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface CheckWeatherViewController : UIViewController <CLLocationManagerDelegate>

//bool var that tells if monitor or not our location
@property (nonatomic) BOOL updateLocation;
//istance of CLLocationManager
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UISegmentedControl *selectedLocation;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (weak, nonatomic) IBOutlet UILabel *centigradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *fahrenheitLabel;

@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;

@property (strong, nonatomic) NSString *locationState;
@property (strong, nonatomic) NSString *locationCity;

@property (strong, nonatomic) NSString *destinationLocationState;
@property (strong, nonatomic) NSString *destinationLocationCity;

@property (strong, nonatomic) WeatherForecast *forecast;

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;


- (IBAction)switchLocation:(id)sender;

- (NSString *)retrieveCoordinates:(NSString *)cityInput;
- (IBAction)refreshView:(id)sender;
- (void)updateView;



@end
