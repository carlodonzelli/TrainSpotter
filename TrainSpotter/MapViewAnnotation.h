//
//  MapViewAnnotation.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 28/08/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *name;

-initWithPosition:(CLLocationCoordinate2D)coordinates;

@end
