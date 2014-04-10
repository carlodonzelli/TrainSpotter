//
//  MyTrainViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 11/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTrainViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *dataSourceArray;

@property (assign, nonatomic) BOOL ascending;

@end
