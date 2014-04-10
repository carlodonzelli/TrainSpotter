//
//  TrainDetail.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 10/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StopDetail.h"

@interface TrainDetail : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *stops;
@property (nonatomic, strong) NSString *state;

@end
