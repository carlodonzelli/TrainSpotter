//
//  ReportTableViewCell.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 07/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *trainNumber;
@property (nonatomic, strong) IBOutlet UILabel *departureStation;
@property (nonatomic, strong) IBOutlet UILabel *arrivalStation;


@end
