//
//  CommentViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 03/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *commentView;

- (IBAction)dismissKeyboardOnTap:(id)sender;


@end
