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
	// Do any additional setup after loading the view.
    //initializing location strings
    _locationState = [[NSString alloc] init];
    _locationCity = [[NSString alloc] init];
    _destinationLocationState = [[NSString alloc] init];
    _destinationLocationCity = [[NSString alloc] init];
    
    
    //initializing location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    WeatherForecast *forecast = [[WeatherForecast alloc] init];
    self.forecast = forecast;
    [self refreshView:self];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//method that invokes webservice, gets results and display data in the view
- (IBAction)refreshView:(id)sender {
    
    [_loadingActivityIndicator startAnimating];
    
    //if current location is selected
    if ( _selectedLocation.selectedSegmentIndex == 0 ) {
        NSLog(@"Current Location selected");
        NSLog( @ "updating for location = %@, %@ ", self.locationCity, self.locationState );
        NSString *encodedState = [self.locationState stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedCity  = [self.locationCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self.forecast queryServiceWithState:encodedState andCity:encodedCity withParent:self];
    }
    if (_selectedLocation.selectedSegmentIndex == 1 ) {
        NSLog(@"Destination Location selected");
        //destination location is selected, put here CHECK-IN destination location
        
        NSString *currentId = theAppDelegate.objectID;
        
        PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
        [query getObjectInBackgroundWithId:currentId block:^(PFObject *currentLoc, NSError *error) {
            // Do something with the returned PFObject in the gameScore variable.
            //NSLog(@"%@", currentLoc);
            NSString *currentDestinationLocation = [currentLoc objectForKey:@"arrivalStation"];
            NSLog(@"Checking the weather for %@", currentDestinationLocation);
            NSString *convertedLocation = [self retrieveCoordinates:currentDestinationLocation];
            NSLog(@"Destination Location: %@", convertedLocation);
            [self.forecast queryServiceWithState:@"IT" andCity:convertedLocation withParent:self];
            
        }];
    }
    NSLog(@"View Refreshed");
}



- (NSString *)retrieveCoordinates:(NSString *)cityInput {
    
    //NSString *result = [[NSString alloc] initWithFormat:@"Milano"];
    
    //NSString *destinationAddress = @"Milano";
    CLGeocoder *forwardGeo = [[CLGeocoder alloc] init];
    [forwardGeo geocodeAddressString:cityInput completionHandler:^(NSArray* placemarks, NSError* error){
        for (CLPlacemark *placemark in placemarks) {
            //NSLog(@"Placemark is %@", placemark);
            //NSLog(@"FOTTUTA LATITUDINE: %f", placemark.location.coordinate.longitude);
            
            self.latitude = [NSNumber numberWithDouble:placemark.location.coordinate.latitude];
            self.longitude = [NSNumber numberWithDouble:placemark.location.coordinate.longitude];
            //NSLog(@"FOTTUTA LAT: %@, FOTTUTA LONG: %@", _latitude, _longitude);
        }
        
    }];
    
    //NSLog(@"LAT: %@, LONG: %@", _latitude, _longitude);
    
    CLLocation *tempLocation = [[CLLocation alloc] initWithLatitude:_latitude.doubleValue longitude:_longitude.doubleValue];
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:tempLocation completionHandler: ^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        //NSLog(@"%@",[NSString stringWithFormat:@"%@,%@", placemark.locality, placemark.administrativeArea] );
        
        dispatch_async( dispatch_get_main_queue(), ^{
            self.destinationLocationState = placemark.administrativeArea;
            self.destinationLocationCity = placemark.locality;
        });
    }];
    
    return self.destinationLocationCity;
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
    
    [_loadingActivityIndicator stopAnimating];
    
    NSLog(@"View UPDATED");
}

#pragma mark CLLocationManager Methods
//delegate method to handle changes in location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"Location: %@", [newLocation description]);
    NSLog(@"Entering update location delegate");
    
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
        NSLog(@"new location found");
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
    NSLog(@"Error: %@", [error description]);
}

//method implemented by the segmented controller
- (IBAction)switchLocation:(id)sender {
    
    if ( _selectedLocation.selectedSegmentIndex == 0 ) {
        _locationManager.distanceFilter = 100;
        [_locationManager startUpdatingLocation];
        [self refreshView:self];
        
    }
    
    if (_selectedLocation.selectedSegmentIndex == 1 ) {
        [_locationManager stopUpdatingLocation];
        [self refreshView:self];
    }
    
}
@end
