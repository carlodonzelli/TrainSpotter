//
//  MapViewViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "MapViewViewController.h"
#import "MapViewAnnotation.h"
#import "MapViewDetailViewController.h"


@interface MapViewViewController ()

@property (strong, nonatomic) NSString *currentTime;
@property (strong, nonatomic) NSString *currentLat;
@property (strong, nonatomic) NSString *currentLong;
@property (strong, nonatomic) NSString *currentAltitude;
@property (strong, nonatomic) NSString *currentHorizontalAcc;
@property (strong, nonatomic) NSString *currentVerticalAcc;
@property (strong, nonatomic) NSString *currentSpeed;
@property (strong, nonatomic) NSString *currentCourse;
@property (strong, nonatomic) UITextField *remiderTextField;

@property CLLocationCoordinate2D reminderLocation;
@property CLRegion *reminderRegion;
@property CLRegion *reminderFixedRegion;

@end


#define BOLOGNA_LATITUDE 44.506136
#define BOLOGNA_LONGITUDE 11.343405

#define OZZANO_LATITUDE 44.451696
#define OZZANO_LONGITUDE 11.488599

#define CASTEL_SAN_PIETRO_LATITUDE 44.408294
#define CASTEL_SAN_PIETRO_LONGITUDE 11.598596

#define IMOLA_LATITUDE 44.359547
#define IMOLA_LONGITUDE 11.718737

#define CASTEL_BOLOGNESE_LATITUDE 44.325398
#define CASTEL_BOLOGNESE_LONGITUDE 11.804016

#define FAENZA_LATITUDE 44.293384
#define FAENZA_LONGITUDE 11.883087

#define FORLI_LATITUDE 44.224063
#define FORLI_LONGITUDE 12.054888

#define CESENA_LATITUDE 44.145177
#define CESENA_LONGITUDE 12.249793

#define RIMINI_LATITUDE 44.064234
#define RIMINI_LONGITUDE 12.574330

#define RICCIONE_LATITUDE 43.999124
#define RICCIONE_LONGITUDE 12.658412

#define CATTOLICA_LATITUDE 43.959638
#define CATTOLICA_LONGITUDE 12.745031

#define PESARO_LATITUDE 43.906431
#define PESARO_LONGITUDE 12.903697

#define RADIUS 5000.0


@implementation MapViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //settin map view properties
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    //setting location properties
    self.location = [[CLLocation alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
    
    [self setupAnnotations];
    
}




//method that tracks location changes
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSLog(@"inside didUpdateLocations");
    
    //getting the last object of the array, which is my last (current) location
    self.location = locations.lastObject;
    
    //saving location data
    self.currentLat = [NSString stringWithFormat:@"%f", self.location.coordinate.latitude];
    self.currentLong = [NSString stringWithFormat:@"%f", self.location.coordinate.longitude];
    self.currentAltitude = [NSString stringWithFormat:@"%f", self.location.altitude];
    self.currentHorizontalAcc = [NSString stringWithFormat:@"%f", self.location.horizontalAccuracy];
    self.currentVerticalAcc = [NSString stringWithFormat:@"%f", self.location.verticalAccuracy];
    self.currentTime = [NSString stringWithFormat:@"%@", self.location.timestamp];
    self.currentSpeed = [NSString stringWithFormat:@"%f", self.location.speed];
    self.currentCourse = [NSString stringWithFormat:@"%f", self.location.course];
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Location Manager Error: %@", [error description]);
    //inform here the user maybe with an UIAlert
}





//method that sets up the map view with centering, zooming and creating annotations
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    NSLog(@"inside didUpdateUserLocation: %@", userLocation.location.description);
    
    //retrieving user coordinates
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //defining a region
    MKCoordinateRegion myRegion = MKCoordinateRegionMakeWithDistance(coordinate, 10000, 10000);
    //setting map zoom level to that region
    [self.mapView setRegion:[self.mapView regionThatFits:myRegion] animated:YES];
}


//method for customizing annotations like with pin color and image
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    NSLog(@"inside viewForAnnotation");
    
    //check if working on user location pin or other pins
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    
    if(annotationView)
        return annotationView;
    else
    {
        //view
        MKPinAnnotationView *myPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        
        //code that delete unused pins from the map, for performane issues. to be tested!!
        //        MKPinAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
        //        if (myPin == nil) {
        //            myPin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        //        }
        
        //pin color
        myPin.pinColor = MKPinAnnotationColorPurple;
        //enabled animated
        myPin.enabled = YES;
        myPin.animatesDrop = YES;
        myPin.canShowCallout = YES;
        //image button
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"railstation.png"]];
        myPin.leftCalloutAccessoryView = imageView;
        myPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //custom image not working if pin customization is active
        //myPin.image = [UIImage imageNamed:@"railStation.png"];
        return myPin;
    }
    return nil;
}

//method that shows a pop up when the user selects more info
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    NSLog(@"inside calloutAccessoryControlTapped");
    
    //annotation
    MapViewAnnotation *myAnnotation = (MapViewAnnotation *)view.annotation;
    //deselect
    [self.mapView deselectAnnotation:myAnnotation animated:YES];
    //altert location
    NSString *msg = [myAnnotation.name stringByAppendingFormat:@"\nLatitude: %f \nLongitude: %f", myAnnotation.coordinate.latitude, myAnnotation.coordinate.longitude];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

//method to define the aspect for the circle overlay
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    NSLog(@"inside viewForOverlay");
    
    MKCircleView *myCircle = [[MKCircleView alloc] initWithCircle:overlay];
    myCircle.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    myCircle.strokeColor = [[UIColor magentaColor] colorWithAlphaComponent:0.6];
    myCircle.lineWidth = 1;
    
    return myCircle;
}


//method to pass data from this view to the map detail view
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    MapViewDetailViewController *mapDetail = [segue destinationViewController];
    
    mapDetail.time = self.currentTime;
    mapDetail.latitude = self.currentLat;
    mapDetail.longitude = self.currentLong;
    mapDetail.altitiude = self.currentAltitude;
    mapDetail.course = self.currentCourse;
    mapDetail.speed = self.currentSpeed;
    mapDetail.horizontalAcc = self.currentHorizontalAcc;
    mapDetail.verticalAcc = self.currentVerticalAcc;
    
}


//sequence of method to define actions for the geofence
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    // regions are stored by system
    NSLog(@"Current monitored regions %@", [self.locationManager monitoredRegions]);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    //entered in the region
    [self.locationManager stopMonitoringForRegion:region];
    [[[UIAlertView alloc] initWithTitle:@"Get off!"
                                message:@"You reached your destination."
                               delegate:nil
                      cancelButtonTitle:@"Dismiss"
                      otherButtonTitles:nil] show];
    
    NSLog(@"You are inside the region: %@", region.description);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    //exited from the region
    NSLog(@"You are outside the region");
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    // kCLErrorRegionMonitoringFailure
    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}



//method associated with a button to start location monitoring
- (IBAction)startLocationServices:(id)sender {
    
    [self.startButton setEnabled:NO];
    [self.stopButton setEnabled:YES];
    [self.detailButton setEnabled:YES];
    
    if ([CLLocationManager locationServicesEnabled] == YES) {
        //everything it's ok
    }
    else {
        //tell the user that location updates are needed and the purpose
    }
    
    //create location manager only if there isn't another one
    if (self.locationManager == nil) {
        //create location manager
        self.locationManager = [CLLocationManager new];
        
    }
    //set its delegate
    [self.locationManager setDelegate:self];
    
    if ([self conformsToProtocol:@protocol(CLLocationManagerDelegate)]) {
        //set to retrieve location updates
    }
    //set config
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLLocationAccuracyHundredMeters];
    
    //start location services
    [self.locationManager startUpdatingLocation];
    NSLog(@"Location Services STARTED");
    [self.locationManager startMonitoringForRegion:self.reminderFixedRegion];
    NSLog(@"Monitorign for Regione STARTED");
    
    //maybe can use: initial user location then updates if significant distance (doesn't use Acuracy or Distance Filters
}



//method associated with a button to stop location monitoring
- (IBAction)stopLocationServices:(id)sender {
    
    [self.reminderButton setEnabled:YES];
    [self.stopButton setEnabled:NO];
    [self.detailButton setEnabled:NO];
    
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Updatign Location STOPPED");
    [self.locationManager stopMonitoringForRegion:self.reminderRegion];
    NSLog(@"Monitoring for Region STOPPED");
    [self.locationManager setDelegate:nil];
    
}

- (IBAction)setReminder:(id)sender {
    
    [self.startButton setEnabled:YES];
    
    UIAlertView *reminderAlert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Insert location below"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"OK", nil];
    
    reminderAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [reminderAlert show];
    [self.reminderButton setEnabled:NO];
    
}

//UIAlertView Delegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSString *city = [NSString stringWithFormat:@"%@", [alertView textFieldAtIndex:0].text];
        
        NSLog(@"Setting Reminder for %@",  city);
        
        [self forwardGeocoding:city];
        
        //self.reminderLocation = CLLocationCoordinate2DMake(43.906431, 12.903697);
        
        //        self.reminderRegion = [[CLRegion alloc]
        //                               initCircularRegionWithCenter:self.reminderLocation
        //                               radius:RADIUS
        //                               identifier:@"PESARO"];
    }
}

-(void)forwardGeocoding:(NSString *) inputCity {
    
    
    CLGeocoder *forwardGeo = [[CLGeocoder alloc] init];
    
    // Geocode a simple string using a completion handler
    [forwardGeo geocodeAddressString:inputCity completionHandler:^(NSArray *placemarks, NSError *error){
        
        // Make sure the geocoder did not produce an error before continuinh
        if(!error){
            
            // Iterate through all of the placemarks returned and output them to the console
            for(CLPlacemark *placemark in placemarks){
                self.reminderRegion = placemark.region;
                NSLog(@"Forward Geo ok for: %@", placemark.locality);
            }
            self.reminderFixedRegion = [[CLRegion alloc]
                                        initCircularRegionWithCenter:self.reminderRegion.center
                                        radius:RADIUS
                                        identifier:self.reminderRegion.identifier];

        }
        else {
            // Our geocoder had an error, output a message to the console
            NSLog(@"There was a forward geocoding error\n%@",
                  [error localizedDescription]);
        }
    }
     ];
}

-(void)setupAnnotations {
    
    //rail station annotations temp data
    NSMutableArray *railStationAnnotations = [[NSMutableArray alloc] init];
    //NSMutableArray *railStationRegions = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    //MKCoordinateRegion region;
    MapViewAnnotation *annotation;
    
    
    //Bologna
    //    region.center.latitude = BOLOGNA_LATITUDE;
    //    region.center.longitude = BOLOGNA_LONGITUDE;
    location.latitude = BOLOGNA_LATITUDE;
    location.longitude = BOLOGNA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Bologna Centrale";
    annotation.name = @"Bologna";
    [railStationAnnotations addObject:annotation];
    //[railStationRegions addObject:region];
    
    //Ozzano dell'emilia
        location.latitude = OZZANO_LATITUDE;
    location.longitude = OZZANO_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Ozzano dell'Emilia";
    annotation.name = @"Ozzano dell'Emilia";
    [railStationAnnotations addObject:annotation];
    
    //Castel S. Pietro
    location.latitude = CASTEL_SAN_PIETRO_LATITUDE;
    location.longitude = CASTEL_SAN_PIETRO_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Castel San Pietro Terme";
    annotation.name = @"Castel San Pietro";
    [railStationAnnotations addObject:annotation];
    
    //Imola
    location.latitude = IMOLA_LATITUDE;
    location.longitude = IMOLA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Imola";
    annotation.name = @"Imola";
    [railStationAnnotations addObject:annotation];
    
    //castel bolognese
    location.latitude = CASTEL_BOLOGNESE_LATITUDE;
    location.longitude = CASTEL_BOLOGNESE_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Castel Bolognese";
    annotation.name = @"Castel Bolognese";
    [railStationAnnotations addObject:annotation];
    
    //faenza
    location.latitude = FAENZA_LATITUDE;
    location.longitude = FAENZA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Faenza";
    annotation.name = @"Faenza";
    [railStationAnnotations addObject:annotation];
    
    //forli
    location.latitude = FORLI_LATITUDE;
    location.longitude = FORLI_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Forli";
    annotation.name = @"Forli";
    [railStationAnnotations addObject:annotation];
    
    //cesena
    location.latitude = CESENA_LATITUDE;
    location.longitude = CESENA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Cesena";
    annotation.name = @"Cesena";
    [railStationAnnotations addObject:annotation];
    
    //rimini
    location.latitude = RIMINI_LATITUDE;
    location.longitude = RIMINI_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Rimini";
    annotation.name = @"Rimini";
    [railStationAnnotations addObject:annotation];
    
    //riccione
    location.latitude = RICCIONE_LATITUDE;
    location.longitude = RICCIONE_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Riccione";
    annotation.name = @"Riccione";
    [railStationAnnotations addObject:annotation];
    
    //cattolica
    location.latitude = CATTOLICA_LATITUDE;
    location.longitude = CATTOLICA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Cattolica";
    annotation.name = @"Cattolica";
    [railStationAnnotations addObject:annotation];
    
    //Pesaro
    location.latitude = PESARO_LATITUDE;
    location.longitude = PESARO_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione di Pesaro";
    annotation.name = @"Pesaro";
    [railStationAnnotations addObject:annotation];
    
    
    //add the pin annotations to the map
    [self.mapView addAnnotations:railStationAnnotations];

}

@end
