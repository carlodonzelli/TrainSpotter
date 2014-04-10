//
//  WeatherForecast.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 22/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckWeatherViewController;

@interface WeatherForecast : NSObject {
    
    //Parent View Controller
    CheckWeatherViewController *viewController;
    
    //Weather Underground Service
    NSString *apiKey;
    NSMutableData *responseData;
    NSURL *theUrl;
}

//Information
@property (weak, nonatomic) NSString *location;

// Current Conditions
@property (weak, nonatomic) NSString *icon;
@property (weak, nonatomic) NSString *condition;
@property (weak, nonatomic) NSString *centigrade;
@property (weak, nonatomic) NSString *fahrenheit;
@property (weak, nonatomic) NSString *humidity;
@property (weak, nonatomic) NSString *wind;

- (void)queryServiceWithState:(NSString *)state andCity:(NSString *)city withParent:(UIViewController *)controller;

@end
