//
//  ViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) PFUser *user;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *sessionToken;


- (IBAction)getStarted:(id)sender;


@end
