//
//  CommentViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 03/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

//two method triggeref when keyboard is shown or dismissed, in order to resize the text input view
- (void)keyboardWasShown:(NSNotification*)notification {
    
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _commentView.frame = CGRectMake(20, 58, _commentView.frame.size.width, (_commentView.frame.size.height - keyboardSize.height + 70));
}
- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    _commentView.frame = CGRectMake(20, 58, 280, 280);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboardOnTap:(id)sender {
    
    [[self view] endEditing:YES];
}



- (IBAction)submitComment:(id)sender {
    
    NSString *userComment = [NSString stringWithFormat: @"%@", _commentView.text];
    
    NSString *currentId = theAppDelegate.objectID;
    
    PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
    [query getObjectInBackgroundWithId:currentId block:^(PFObject *feedback, NSError *error) {
        
        [feedback setObject:userComment forKey:@"userComment"];
        
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                NSLog(@"User said: %@", userComment);
                NSLog(@"Saved in Comment View.");
                //NSLog(@"Current object ID checkin view: %@", currentId);
            } else {
                NSLog(@"Something wrong happened: %@", error);
            }
        }];
    }];    
}

@end
