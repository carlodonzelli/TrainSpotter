//
//  CheckTrainViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 10/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"


@interface CheckTrainViewController : UIViewController <MBProgressHUDDelegate, ASIHTTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UITextField *trainNumbTextField;

- (IBAction)searchTrain:(id)sender;

@end
