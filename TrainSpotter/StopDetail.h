//
//  StopDetail.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 10/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopDetail : NSObject

@property (nonatomic, strong) NSString *stationName;
@property (nonatomic, strong) NSString *scheduledTime;
@property (nonatomic, strong) NSString *effectiveTime;
@property (nonatomic, strong) NSString *scheduledBinary;
@property (nonatomic, strong) NSString *effectiveBinary;

@end
