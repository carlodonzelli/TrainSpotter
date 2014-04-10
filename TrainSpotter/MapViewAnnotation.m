//
//  MapViewAnnotation.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 28/08/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

-initWithPosition:(CLLocationCoordinate2D)coordinates {
    
    if (self = [super init]) {
        self.coordinate = coordinates;
    }
    return self;
}

@end
