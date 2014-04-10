//
//  CheckWeatherViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 22/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "CheckWeatherViewController.h"
#import "WeatherForecast.h"

@interface CheckWeatherViewController ()

@end

@implementation CheckWeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //initializing location strings
    self.locationState = [[NSString alloc] init];
    self.locationCity = [[NSString alloc] init];
    self.destinationLocationState = [[NSString alloc] init];
    self.destinationLocationCity = [[NSString alloc] init];
    
    
    //initializing location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    WeatherForecast *forecast = [[WeatherForecast alloc] init];
    self.forecast = forecast;
    //[self refreshView:self];
    if ( _selectedLocation.selectedSegmentIndex == 0 ) {
        _locationManager.distanceFilter = 100;
        [_locationManager startUpdatingLocation];
        //[self refreshView:self];
        
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//method that invokes webservice, gets results and display data in the view
- (IBAction)refreshView:(id)sender {
    
    //[_loadingActivityIndicator startAnimating];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Fetching Data...";
    hud.dimBackground = YES;
    
    //if current location is selected
    if ( _selectedLocation.selectedSegmentIndex == 0 ) {
        NSLog(@"Current Location selected");
        NSLog(@"Checking weather for %@, %@ ", self.locationCity, self.locationState );
        NSString *encodedState = [self.locationState stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedCity  = [self.locationCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"Checked weather for %@, %@ ", encodedCity, encodedState );
        [self.forecast queryServiceWithState:encodedState andCity:encodedCity withParent:self];
    }
    if (_selectedLocation.selectedSegmentIndex == 1 ) {
        NSLog(@"Destination Location selected");
        //destination location is selected, put here CHECK-IN destination location
        
        NSString *currentId = theAppDelegate.objectID;
        
        PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
        //PFObject *temp = [query getObjectWithId:currentId];
        //NSString *currentDestinationLocation = [temp objectForKey:@"arrivalStation"];
        [query getObjectInBackgroundWithId:currentId block:^(PFObject *currentLoc, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", currentLoc);
            NSString *currentDestinationLocation = [currentLoc objectForKey:@"arrivalStation"];
            NSLog(@"Checking the weather for %@", currentDestinationLocation);
            //NSString *convertedLocation =
            [self retrieveCoordinates:currentDestinationLocation];
            //NSLog(@"Destination Location: %@", convertedLocation);
            //[self.forecast queryServiceWithState:@"IT" andCity:convertedLocation withParent:self];
            
        }];
    }
    NSLog(@"View Refreshed");
}



- (void)retrieveCoordinates:(NSString *)cityInput {
    
    CLGeocoder *forwardGeo = [[CLGeocoder alloc] init];
    //starting form city name, retrieving coordinates
    [forwardGeo geocodeAddressString:cityInput completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark *placemark in placemarks) {
            self.latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
            self.longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
        }
        CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
        CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
        //starting from coordinates, retrieving city name
        [reverseGeocoder reverseGeocodeLocation:tempLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            dispatch_async( dispatch_get_main_queue(), ^{
                self.destinationLocationState = placemark.administrativeArea;
                self.destinationLocationCity = placemark.locality;
                NSLog(@"Destination Location: %@", self.destinationLocationCity);
                [self.forecast queryServiceWithState:@"IT" andCity:self.destinationLocationCity withParent:self];
            });
        }];
    }];
}

//method that updates UI elements
-(void)updateView {
    
    _cityLabel.text = self.forecast.location;
    
    NSURL *url = [NSURL URLWithString:(NSString *)self.forecast.icon];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    _weatherImage.image = [[UIImage alloc] initWithData:data];
    _weatherLabel.text = self.forecast.condition;
    _centigradeLabel.text = [NSString stringWithFormat:@"%@ °C", self.forecast.centigrade];
    _fahrenheitLabel.text = [NSString stringWithFormat:@"(%@ °F)", self.forecast.fahrenheit];
    _humidityLabel.text = [NSString stringWithFormat:@"%@",self.forecast.humidity];
    _windLabel.text = self.forecast.wind;
    
    //[_loadingActivityIndicator stopAnimating];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSLog(@"Weather View Updated");
}

#pragma mark CLLocationManager Methods
//delegate method to handle changes in location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", [newLocation description]);
    NSLog(@"Entering Update Location Delegate");
    
    CLLocationCoordinate2D newCoordinate = [newLocation coordinate];
    CLLocationCoordinate2D oldCoordinate = [oldLocation coordinate];
    
    NSString *newString=[[NSString alloc] initWithFormat:@"NEW latitude:%f longitude:%f",newCoordinate.latitude, newCoordinate.longitude];
    NSLog(@"%@", newString);
    NSString *oldString=[[NSString alloc] initWithFormat:@"OLD latitude:%f longitude:%f",oldCoordinate.latitude, oldCoordinate.longitude];
    NSLog(@"%@", oldString);
    
    //    BOOL test;
    //    test = newLocation != oldLocation;
    //    NSLog(@"Test: %d", test);
    
    if ( newLocation != oldLocation ){
        
        NSLog(@"New Location Found!");
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",[NSString stringWithFormat:@"%@,%@", placemark.locality, placemark.administrativeArea] );
            dispatch_async( dispatch_get_main_queue(), ^{
                self.locationState = placemark.administrativeArea;
                self.locationCity = placemark.locality;
                [self refreshView:self];
            });
        }];
    }
}

//delegate method to handle any errors that occur
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"Error in Location Manager!: %@", [error description]);
}

//method implemented by the segmented controller
- (IBAction)switchLocation:(id)sender {
    
    //current location
    if ( _selectedLocation.selectedSegmentIndex == 0 ) {
        
        //create location manager only if there isn't another one
        if (self.locationManager == nil) {
            //create location manager
            self.locationManager = [CLLocationManager new];
            
        }
        //set its delegate
        [self.locationManager setDelegate:self];
        _locationManager.distanceFilter = 100;
        [_locationManager startUpdatingLocation];
        [self refreshView:self];
        
    }
    
    //destination location
    if (_selectedLocation.selectedSegmentIndex == 1 ) {
        [_locationManager stopUpdatingLocation];
        [self refreshView:self];
    }
    
}
@end
