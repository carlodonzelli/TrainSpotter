    //
//  AppDelegate.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (NSString *)stringFromStatus:(NetworkStatus )status;

@property (strong, nonatomic) NSString *trainNumber;
@property (strong, nonatomic) NSString *objectID;

@end
