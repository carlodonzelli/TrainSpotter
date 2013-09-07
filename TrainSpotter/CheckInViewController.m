//
//  CheckInViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 15/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CheckInViewController.h"


@interface CheckInViewController ()

@end

@implementation CheckInViewController

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
    //creating a label with username
    _loggedUser.text = [PFUser currentUser].username;
    
    [_scroller setScrollEnabled:YES];
    [_scroller setContentSize:CGSizeMake(280, 320)];
    
    
    //self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view, typically from a nib.
    CGRect frame = CGRectMake (120.0, 185.0, 80, 80);
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [self.view addSubview:self.activityIndicatorView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doCheckIn:(id)sender {
    
    [self.activityIndicatorView startAnimating];

    //retrieve the current user
    PFUser *user = [PFUser currentUser];
    
    //creatin temp strings where to save input data
    NSString *trainNum = [NSString stringWithFormat: @"%@", _trainNumber.text];
    NSString *depStation = [NSString stringWithFormat: @"%@", _departureStation.text];
    NSString *arrStation = [NSString stringWithFormat: @"%@", _arrivalStation.text];
    
    //creating a new object with class and properties
    PFObject *checkIn = [PFObject objectWithClassName:@"CheckIn"];
    [checkIn setObject:user.username forKey:@"user"];
    [checkIn setObject:trainNum forKey:@"trainNumber"];
    [checkIn setObject:depStation forKey:@"departureStation"];
    [checkIn setObject:arrStation forKey:@"arrivalStation"];
    [checkIn setObject:@"" forKey:@"cleaningValue"];
    [checkIn setObject:@"" forKey:@"stinkValue"];
    [checkIn setObject:@"" forKey:@"crowdingValue"];
    [checkIn setObject:@"" forKey:@"qualityValue"];
    [checkIn setObject:@"" forKey:@"userComment"];
    
    
    //theAppDelegate.trainNumber = trainNum;
    //theAppDelegate.objectID = [checkIn objectId];
    
    [checkIn saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            theAppDelegate.trainNumber = trainNum;
            theAppDelegate.objectID = [checkIn objectId];
            NSLog(@"Saved CheckIn class into PARSE!");
            NSLog(@"Current object ID in CheckInView: %@", theAppDelegate.objectID);
            NSLog(@"Checked In train n°: %@, From %@ to %@", trainNum, depStation, arrStation);
        } else {
            NSLog(@"Something wrong happened: %@", error);
        }
    }];
    [self.activityIndicatorView stopAnimating];
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}


- (IBAction)backgroundTap:(id)sender {
    [self.trainNumber resignFirstResponder];
    [self.departureStation resignFirstResponder];
    [self.arrivalStation resignFirstResponder];
}

- (IBAction)logout:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Logout"
                                message:@"Are you sure you want to logout?"
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
}

//UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //if user clic yes (wants to logout)
    if (buttonIndex == 1) {
        [PFUser logOut];
        NSLog(@"Logged Out");
        [self performSegueWithIdentifier:@"fromCheckInToHome" sender:self];
    }
}


//next four methods are used to scrool up view while keyboard appears
-(void)viewWillAppear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)keyboardWillShow:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
    
    CGRect rect = self.view.frame;
    rect.size.height -= keyboardSize.height;
    
    if (!CGRectContainsPoint(rect, self.arrivalStation.frame.origin)) {
        
        CGPoint scrollPoint = CGPointMake(0.0, self.arrivalStation.frame.origin.y - (keyboardSize.height - self.arrivalStation.frame.size.height - 20));
        // _commentView.frame = CGRectMake(0, 0, _commentView.frame.size.width, _commentView.frame.size.height - keyboardSize.height);
        [self.scroller setContentOffset:scrollPoint animated:NO];
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scroller.contentInset = contentInsets;
    self.scroller.scrollIndicatorInsets = contentInsets;
}

@end
