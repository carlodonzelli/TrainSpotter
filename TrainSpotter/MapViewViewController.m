//
//  MapViewViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 19/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "MapViewViewController.h"

@interface MapViewViewController ()

@end

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
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600);
    mapView.region = reg;
}

@end
