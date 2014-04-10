//
//  CommentViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 03/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FormViewController.h"
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface CommentViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *commentView;
@property (weak, nonatomic) NSString *currentObjectId;

- (IBAction)dismissKeyboardOnTap:(id)sender;
- (IBAction)submitComment:(id)sender;


@end
