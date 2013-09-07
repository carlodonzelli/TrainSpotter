//
//  FormViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "FormViewController.h"
#import "CommentViewController.h"

@interface FormViewController ()

@property NSMutableArray *ratingArray;

@end

@implementation FormViewController

int pageCount = 4;
int currentPage = 0;
int nextPage = 0;
//PFObject *feedback;

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
    //_ratingSegment
    [_ratingSegment setSelectedSegmentIndex:-1];
    [_nextBarButton setEnabled:NO];
    _ratingArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    //_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [_scrollView setScrollEnabled:NO];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [_scrollView setContentSize:CGSizeMake(280*pageCount, 280)];
    
    //NSArray *titleArray = @[@"Smell", @"Capacity", @"Service", @"Temperature"];
    NSArray *questionArray = @[@"Cleaning Question", @"Stink Question", @"Crowding Question", @"Quality of Service Question"];
    
    for(int i = 0; i < pageCount; i++){
        
        //Create your labels and segmented control here
        //NSLog(@"Creatin labels....");
        //        UILabel *label = [[UILabel alloc] init];
        //        [label setText:[titleArray objectAtIndex:i]];
        //        label.backgroundColor = [UIColor clearColor];
        //        label.textColor = [UIColor whiteColor];
        //        label.frame = CGRectMake(280*i,0,280,280);
        //        [_scrollView addSubview:label];
        UITextField *questionField = [[UITextField alloc] init];
        questionField.frame = CGRectMake(280*i,0,280,280);
        //questionField.borderStyle = UITextBorderStyleLine;
        questionField.font = [UIFont systemFontOfSize:15];
        questionField.userInteractionEnabled = NO;
        questionField.backgroundColor = [UIColor clearColor];
        questionField.textColor = [UIColor whiteColor];
        [questionField setText:[questionArray objectAtIndex:i]];
        //questionField.placeholder = @"enter text";
        //questionField.autocorrectionType = UITextAutocorrectionTypeNo;
        //questionField.keyboardType = UIKeyboardTypeDefault;
        //questionField.returnKeyType = UIReturnKeyDone;
        //questionField.clearButtonMode = UITextFieldViewModeWhileEditing;
        questionField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //questionField.delegate = self;
        [_scrollView addSubview:questionField];
        
    }
    //NSLog(@"Current object ID form view: %@", theAppDelegate.objectID);

}

- (IBAction)nextButtonPressed:(id)sender {
    
    [_ratingSegment setSelectedSegmentIndex:-1];
    
    currentPage = (_scrollView.contentOffset.x/280);
    nextPage = currentPage + 1;
    //NSLog(@"Next page: %d", nextPage);
    //NSLog(@"Current progress: %f", ((((float)nextPage + 1) * 2) / 10));
    _currentProgress.progress =  ((((float)nextPage + 1) * 2) / 10);
    
    [_scrollView scrollRectToVisible:CGRectMake(280*nextPage, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    //    NSLog(@"current X: %d", 280*nextPage);
    //    NSLog(@"current Y: %f", _scrollView.frame.origin.y);
    //    NSLog(@"current width: %f", _scrollView.frame.size.width);
    //    NSLog(@"current height: %f", _scrollView.frame.size.height);
    [_nextBarButton setEnabled:NO];
    
    //going to the last question to the last step of the survey
    if (nextPage == 4) {
        
        //retrieve the current user
        //PFUser *user = [PFUser currentUser];
        
        //creatin temp strings where to save input data
        NSString *cleaningRate = [NSString stringWithFormat: @"%@", [_ratingArray objectAtIndex:0]];
        NSString *stinkRate = [NSString stringWithFormat: @"%@", [_ratingArray objectAtIndex:1]];
        NSString *crowdingRate = [NSString stringWithFormat: @"%@", [_ratingArray objectAtIndex:2]];
        NSString *qualityRate = [NSString stringWithFormat: @"%@", [_ratingArray objectAtIndex:3]];
        
        NSString *currentId = theAppDelegate.objectID;
        
        PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
        [query getObjectInBackgroundWithId:currentId block:^(PFObject *feedback, NSError *error) {
            
            // Now let's update it with some new data.
            [feedback setObject:cleaningRate forKey:@"cleaningValue"];
            [feedback setObject:stinkRate forKey:@"stinkValue"];
            [feedback setObject:crowdingRate forKey:@"crowdingValue"];
            [feedback setObject:qualityRate forKey:@"qualityValue"];
            //[feedback setObject:user forKey:@"user"];
            
            [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"Saved in FormView.");
                    NSLog(@"Submitted Values: %@, %@, %@, %@.", [_ratingArray objectAtIndex:0], [_ratingArray objectAtIndex:1], [_ratingArray objectAtIndex:2], [_ratingArray objectAtIndex:3]);
                    //NSLog(@"Current object ID checkin view: %@", currentId);
                    [self performSegueWithIdentifier:@"fromQuestionToFinal" sender:self];
                } else {
                    NSLog(@"Something wrong happened: %@", error);
                }
            }];            
        }];
    }
}

////method to pass data from this view to the comment view
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    CommentViewController *commentView = [segue destinationViewController];
//    commentView.currentObjectId = [feedback objectId];
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectRate:(id)sender {
    
    //NSLog(@"Current page: %d", currentPage);
    //NSLog(@"Next page: %d", nextPage);
    
    NSString *value = [_ratingSegment titleForSegmentAtIndex:_ratingSegment.selectedSegmentIndex];
    //NSLog(@"Selected Value: %@", value);
    
    [_ratingArray addObject:value];
    
    [_nextBarButton setEnabled:YES];
    
}



@end
