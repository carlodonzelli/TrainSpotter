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

- (void)keyboardWasShown:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _commentView.frame = CGRectMake(0, 0, _commentView.frame.size.width, _commentView.frame.size.height - keyboardSize.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    _commentView.frame = CGRectMake(0, 0, _commentView.frame.size.width, _commentView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissKeyboardOnTap:(id)sender {
    
    [[self view] endEditing:YES];
}
@end
