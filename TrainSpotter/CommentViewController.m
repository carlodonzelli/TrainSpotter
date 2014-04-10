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

-(void)viewWillAppear:(BOOL)animated {
    
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//adding selector for keyboard actions
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


//saving the user's comment to the Parse object
- (IBAction)submitComment:(id)sender {
    
    if ([self.commentView.text length]) {
        
        NSString *userComment = [NSString stringWithFormat: @"%@", _commentView.text];
        
        NSString *currentId = theAppDelegate.objectID;
        
        //creating the query
        PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
        [query getObjectInBackgroundWithId:currentId block:^(PFObject *feedback, NSError *error) {
            
            //setting data
            [feedback setObject:userComment forKey:@"userComment"];
            //saving data
            [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                    NSLog(@"User said: %@", userComment);
                    NSLog(@"Saved in Comment View.");
                } else {
                    NSLog(@"Something wrong happened: %@", error);
                }
            }];
        }];
    } else {
        //if the user don't write anything, he is notified
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Please write some comment."
                                   delegate:self
                          cancelButtonTitle:@"Ok8"
                          otherButtonTitles:nil] show];
    }
}

@end
