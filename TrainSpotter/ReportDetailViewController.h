//
//  ReportDetailViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 08/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportTableViewCell.h"

@interface ReportDetailViewController : UITableViewController

@property (retain, nonatomic) NSString *trainNumber;
@property (retain, nonatomic) NSString *departStation;
@property (retain, nonatomic) NSString *arrivStation;
@property (retain, nonatomic) NSString *cleaningValue;
@property (retain, nonatomic) NSString *stinkValue;
@property (retain, nonatomic) NSString *crowdingValue;
@property (retain, nonatomic) NSString *qualityValue;
@property (retain, nonatomic) NSString *noiseLevel;
@property (retain, nonatomic) NSString *commentValue;
@property (retain, nonatomic) UIImage *userImage;


@property (weak, nonatomic) IBOutlet UILabel *trainNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *departStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrivStationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cleaningValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stinkValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *crowdingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *qualityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *noiseLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;




//-(void)setLabel:(UILabel *)myLabel withText:(NSString *)myString;
//- (void)updateTrainNumberLabel;
//- (void)setTrainNumber:(NSString *)trainNumber;

@end
