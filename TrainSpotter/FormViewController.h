//
//  FormViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface FormViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextView *firstQuestion;
@property (weak, nonatomic) IBOutlet UITextView *secondQuestion;
@property (weak, nonatomic) IBOutlet UITextView *thirdQuestion;
@property (weak, nonatomic) IBOutlet UITextView *fourthQuestion;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *ratingSegment;

@property (weak, nonatomic) IBOutlet UIProgressView *currentProgress;


- (IBAction)selectRate:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;





@end
