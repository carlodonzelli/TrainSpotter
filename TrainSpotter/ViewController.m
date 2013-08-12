//
//  ViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ViewController.h"
#import "MyLogInViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


//GET STARTED BUTTON
- (IBAction)getStarted:(id)sender {
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        MyLogInViewController *logInViewController = [[MyLogInViewController alloc] init];
        logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton | PFLogInFieldsSignUpButton |PFLogInFieldsPasswordForgotten | PFLogInFieldsDismissButton | PFLogInFieldsFacebook | PFLogInFieldsTwitter;
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
    else {
        _user = [PFUser currentUser];
        _username = _user.username;
        NSString *alertMsg = [NSString stringWithFormat: @"Currently logged in as: %@", _username];
        
        [[[UIAlertView alloc] initWithTitle:@"Login"
                                    message:alertMsg
                                   delegate:self
                          cancelButtonTitle:@"OK" //ok=0, logout=1, continue=2
                          otherButtonTitles:@"Logout", @"Continue", nil] show];
    }
}



//DELEGATE METHODS FOR LOG IN
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
   
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        NSLog(@"Begin login process");
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    NSLog(@"Interrupt login process");
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self performSegueWithIdentifier:@"fromHomeToCheckIn" sender:self];
    NSLog(@"User successfully logged in!");
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"Log In screen dismissed");
}




//DELEGATE METHODS FOR SIGN UP
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        NSLog(@"Missing Information!");
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL]; // Dismiss the PFSignUpViewController
    [self performSegueWithIdentifier:@"fromHomeToThankYou" sender:self];
    NSLog(@"User successfully signed up!");
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"Sign Up View dismissed");
}

//UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if user clic logout button
    if (buttonIndex == 1) {
        [PFUser logOut];
    } else
        //if user clic continue
        if (buttonIndex == 2) {
        //NSLog(@"CONTINUE");
        [self performSegueWithIdentifier:@"fromHomeToCheckIn" sender:self];
    }
}

@end
