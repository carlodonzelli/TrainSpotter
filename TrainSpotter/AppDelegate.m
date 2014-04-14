//
//  AppDelegate.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //setting parse app data values
    [Parse setApplicationId:@"insert here ID"
                  clientKey:@"insert here Key"];
    
    //enabling analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Override point for customization after application launch.
    //[application setStatusBarHidden:NO];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSLog(@"Network Status: %@", [self stringFromStatus:status]);
    
    //checking the type of connection. if there is no connection user will be advised
    if (status == NotReachable) {
        
        [[[UIAlertView alloc] initWithTitle:@"Network Error"
                                   message:@"Can't establish a connection with the server!"
                                   delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil] show];
    }
    return YES;
}


- (NSString *)stringFromStatus:(NetworkStatus) status {
    NSString *string;
    switch(status) {
        case NotReachable:
            string = @"Not Reachable";
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WiFi";
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            break;
        default:
            string = @"Unknown";
            break;
    }
    return string;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
