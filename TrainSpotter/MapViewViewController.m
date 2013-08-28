//
//  MapViewViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "MapViewViewController.h"
#import "MapViewAnnotation.h"


@interface MapViewViewController ()

@end

#define BOLOGNA_LATITUDE 44.506136
#define BOLOGNA_LONGITUDE 11.343405

#define PESARO_LATITUDE 43.906431
#define PESARO_LONGITUDE 12.903697

@implementation MapViewViewController

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
    self.mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //retrieving user coordinates
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    //defining a region
    MKCoordinateRegion myRegion = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    //setting map zoom level to that region
    [self.mapView setRegion:[self.mapView regionThatFits:myRegion] animated:YES];
    
    //adding an annotation for my current location
//    MKPointAnnotation *myPointer = [[MKPointAnnotation alloc] init];
//    myPointer.coordinate = userLocation.coordinate;
//    myPointer.title = @"Where am I?";
//    myPointer.subtitle = @"I'm here!!!";
    
//    [self.mapView addAnnotation:myPointer];
    
    //rail station annotations temp data
    NSMutableArray *railStationAnnotations = [[NSMutableArray alloc] init];
    CLLocationCoordinate2D location;
    //MKOverlayView *circleOverlay;
    MKCoordinateRegion region;
    //MKCircle *circle;
    MapViewAnnotation *annotation;
    
    //Bologna Rail Station Annotation
    region.center.latitude = BOLOGNA_LATITUDE;
    region.center.longitude = BOLOGNA_LONGITUDE;
    location.latitude = BOLOGNA_LATITUDE;
    location.longitude = BOLOGNA_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione Bologna Centrale";
    annotation.name = @"Bologna";
    [railStationAnnotations addObject:annotation];
//    circle = [MKCircle circleWithCenterCoordinate:region.center radius:1000];
    
    
    //Pesaro Rail Station Annotation
    region.center.latitude = PESARO_LATITUDE;
    region.center.longitude = PESARO_LONGITUDE;
    location.latitude = PESARO_LATITUDE;
    location.longitude = PESARO_LONGITUDE;
    annotation = [[MapViewAnnotation alloc] initWithPosition:location];
    annotation.title = @"Stazione Pesaro";
    annotation.name = @"Pesaro";
    [railStationAnnotations addObject:annotation];
    //[railStationRegions addObject:region];
//    [self.mapView setRegion:region];
//    circle = [MKCircle circleWithCenterCoordinate:region.center radius:1000];
//    [self.mapView addOverlay:circle];

    
    //add the pin annotations to the map
    [self.mapView addAnnotations:railStationAnnotations];
    //[self.mapView addOverlays:railStationRegions];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
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
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"railStation_pin.png"]];
        myPin.leftCalloutAccessoryView = imageView;
        myPin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //custom image not working if pin customization is active
        //myPin.image = [UIImage imageNamed:@"railStation.png"];
        return myPin;
    }
    return nil;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    //annotation
    MapViewAnnotation *myAnnotation = (MapViewAnnotation *)view.annotation;
    //deselect
    [self.mapView deselectAnnotation:myAnnotation animated:YES];
    //altert location
    NSString *msg = [myAnnotation.name stringByAppendingFormat:@"\nLatitude: %f \nLongitude: %f", myAnnotation.coordinate.latitude, myAnnotation.coordinate.longitude];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location" message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    
    MKCircleView *myCircle = [[MKCircleView alloc] initWithCircle:overlay];
    myCircle.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    myCircle.strokeColor = [[UIColor magentaColor] colorWithAlphaComponent:0.6];
    myCircle.lineWidth = 1;
    
    return myCircle;
}

@end
