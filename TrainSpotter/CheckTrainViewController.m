//
//  CheckTrainViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 10/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CheckTrainViewController.h"

@interface CheckTrainViewController () {
    
    MBProgressHUD *hud;
    
}

@end

@implementation CheckTrainViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchTrain:(id)sender {
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    // Set determinate mode
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.delegate = self;
    hud.labelText = @"Fetching data...";
    [hud show:YES];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://mobile.viaggiatreno.it/vt_pax_internet/mobile/numero"]];
    
    //[request setHTTPMethod:@"POST"];
    
    [request setPostValue:@"9816" forKey:@"numeroTreno"];
    [request setPostValue:@"numero" forKey:@"tipoRicerca"];
    [request setPostValue:@"IT" forKey:@"lang"];
    
    [request setTimeOutSeconds:10];
    
    [request startSynchronous];
    
    int statusCode = [request responseStatusCode];
    NSString *responseString = [request responseString];
    
    NSLog(@"fine chiamata %@", responseString);
        
    //NSLog(@"responseString:\n%@", responseString);
    
    NSString *value = @"gi99giu1gi";
    
    NSScanner *theScanner = [NSScanner scannerWithString:responseString];
    // find start of IMG tag
    [theScanner scanUpToString:@"<a href=" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"href" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&value];
        // "url" now contains the URL of the img
    }
    
    NSArray *split = [[NSArray alloc] init];
    split = [value componentsSeparatedByString:@"&"];
    int count = 0;
    for (NSString *s in split) {
        if ([s hasPrefix:@"codLocOrig"]) {
            NSString *stringacodLocOrig = [split objectAtIndex:count];
            NSArray *arrayCode = [stringacodLocOrig componentsSeparatedByString:@"="];
            value = [arrayCode objectAtIndex:1];
            
            break;
        }
        count ++;
             
    }
    NSLog(@"CAMPO HIDDEN:%@", value);
    
    
     ASIFormDataRequest *request2 = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://mobile.viaggiatreno.it/vt_pax_internet/mobile/scheda?dettaglio=visualizza&numeroTreno=9816&codLocOrig=%@&tipoRicerca=numero&lang=IT", value]]];
    
      [request2 setRequestMethod:@"GET"];
    [request2 setTimeOutSeconds:10];
    [request2 startSynchronous];
    
    int statusCode2 = [request2 responseStatusCode];
    NSString *responseString2 = [request2 responseString];
    [hud show:NO];
    NSLog(@"fine chiamata %@", responseString2);
    
    theScanner = [NSScanner scannerWithString:responseString2];
    // find start of IMG tag
    [theScanner scanUpToString:@"<h2>" intoString:nil];
    if (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"</h2>" intoString:nil];
        NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
        [theScanner scanUpToCharactersFromSet:charset intoString:nil];
        [theScanner scanCharactersFromSet:charset intoString:nil];
        [theScanner scanUpToCharactersFromSet:charset intoString:&value];
        // "url" now contains the URL of the img
    }
}
@end
