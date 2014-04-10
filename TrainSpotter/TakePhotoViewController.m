//
//  TakePhotoViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 25/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "TakePhotoViewController.h"

@interface TakePhotoViewController () {
    
    UIImage *userImage;
    NSData *userImageData;
}

@end

@implementation TakePhotoViewController

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
	// Do any additional setup after loading the view.
    self.photoInfoLabel.text = @"No Image loaded, take a pic!";
    NSLog(@"Photo view loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//method triggered when the user press the take photo button, it set its delegates
- (IBAction)takePhotoButton:(id)sender {
    
    [self startCameraControllerFromViewController:self usingDelegate:self];
    NSLog(@"Taking photo...");
}

#pragma mark - UIImagePickerControllerDelegate methods
- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>) delegate {
    
    //there is a built-in camera on the device and delegates are set?
	if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil))
		return NO;
    
	UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    //camera set as source
	cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSLog(@"Image Picker Controller created...");
    
	cameraUI.delegate = delegate;
    //present the take photo view
	[controller presentViewController:cameraUI animated:YES completion:nil];
    NSLog(@"Showing the camera picker");
	return YES;
}


//when the user took a photo
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
	userImage = info[UIImagePickerControllerOriginalImage];
	self.photoInfoLabel.text = [NSString stringWithFormat:@"Image captured at: %d x %d resolution", (int)userImage.size.width, (int)userImage.size.height];
	self.imagePreview.image = userImage;
    NSLog(@"Image saved and previewed!");
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	[self dismissViewControllerAnimated:YES completion:nil];
}


//method triggered when the user press the save photo button, it set its delegates
- (IBAction)savePhotoButton:(id)sender {
    
    if(self.imagePreview.image) {
        NSLog(@"Trying to save image...");
		self.photoInfoLabel.text = @"Saving image...";
		UIImageWriteToSavedPhotosAlbum(self.imagePreview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
	} else {
        NSLog(@"No image to save :(");
        [[[UIAlertView alloc] initWithTitle:@"Can't save!"
                                    message:@"First take a pic"
                                   delegate:nil
                          cancelButtonTitle:@"Dismiss"
                          otherButtonTitles:nil] show];
	}
}


#pragma mark - Save image callbacks
- (void) image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    
	if(error) {
		self.photoInfoLabel.text = [NSString stringWithFormat:@"Error %d: %@", error.code, error.localizedDescription];
	} else {
        
        // Resize image
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect: CGRectMake(0, 0, 640, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        userImageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        [self uploadImage:userImageData];
        
		self.photoInfoLabel.text = @"Image saved.";
        NSLog(@"Image saved");
		//self.imagePreview.image = nil;
	}
}


- (void)uploadImage:(NSData *)imageData {
    
    
    NSString *currentId = theAppDelegate.objectID;
    
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading image...";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            
            //retreiving the object
            PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
            [query getObjectInBackgroundWithId:currentId block:^(PFObject *feedback, NSError *error) {
                
                [feedback setObject:imageFile forKey:@"userImage"];
                
                [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        
                        NSLog(@"User uploaded %@ image", imageFile.name);
                        NSLog(@"Saved in Upload Photo View.");
                        
                        //NSLog(@"Current object ID checkin view: %@", currentId);
                        [[[UIAlertView alloc] initWithTitle:@"All done!"
                                                    message:@"Thank you, your data has been saved!"
                                                   delegate:self
                                          cancelButtonTitle:@"Go Back"
                                          otherButtonTitles:nil] show];
                        
                    } else {
                        NSLog(@"Something wrong happened: %@", error);
                    }
                }];
            }];
        }
        else {
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
}


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self performSegueWithIdentifier:@"fromOpinionToTools" sender:self];
}

@end
