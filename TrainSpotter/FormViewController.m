//
//  FormViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 02/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()

@end

@implementation FormViewController

int pageCount = 4;
int currentPage = 1;

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
    
    //_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    [_scrollView setScrollEnabled:NO];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    
    [_scrollView setContentSize:CGSizeMake(280*pageCount, 280)];
    
    //NSArray *titleArray = @[@"Smell", @"Capacity", @"Service", @"Temperature"];
    NSArray *questionArray = @[@"Smell question", @"Capacity question", @"Service question", @"Temperature question"];
    
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
    
}
    
- (IBAction)nextButtonPressed:(id)sender {
    
    [_ratingSegment setSelectedSegmentIndex:-1];
    
    currentPage = (_scrollView.contentOffset.x/280);
    int nextPage = currentPage + 1;
    NSLog(@"Next page: %d", nextPage);
    NSLog(@"Current progress: %f", ((((float)nextPage + 1) * 2) / 10));
    _currentProgress.progress =  ((((float)nextPage + 1) * 2) / 10);
    
    [_scrollView scrollRectToVisible:CGRectMake(280*nextPage, _scrollView.frame.origin.y, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
//    NSLog(@"current X: %d", 280*nextPage);
//    NSLog(@"current Y: %f", _scrollView.frame.origin.y);
//    NSLog(@"current width: %f", _scrollView.frame.size.width);
//    NSLog(@"current height: %f", _scrollView.frame.size.height);
    [_nextBarButton setEnabled:NO];
    
    if (nextPage == 4) {
        NSLog(@"going to final step");
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard.storyboard" bundle:nil];
//        UIViewController *commentView = [mainStoryboard instantiateViewControllerWithIdentifier:@"finalStepController"];
//        [self presentViewController:commentView animated:YES completion:nil];
        [self performSegueWithIdentifier:@"fromQuestionToFinal" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectRate:(id)sender {
    NSString *value = [_ratingSegment titleForSegmentAtIndex:_ratingSegment.selectedSegmentIndex];
    NSLog(@"Selected Value: %@", value);
    
    [_nextBarButton setEnabled:YES];
    
}



@end
