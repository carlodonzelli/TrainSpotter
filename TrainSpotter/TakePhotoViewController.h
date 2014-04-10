//
//  TakePhotoViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 25/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#define theAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface TakePhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate> {
    
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}

@property (weak, nonatomic) IBOutlet UILabel *photoInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;


- (IBAction)takePhotoButton:(id)sender;
- (IBAction)savePhotoButton:(id)sender;
//- (IBAction)uploadPhoto:(id)sender;

- (void)uploadImage:(NSData *)imageData;


@end
