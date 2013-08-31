//
//  MapViewViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapViewViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, retain) CLLocationManager *locationManager;

- (IBAction)startLocationServices:(id)sender;
- (IBAction)stopLocationServices:(id)sender;



@end
