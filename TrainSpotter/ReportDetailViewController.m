//
//  ReportDetailViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 08/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ReportDetailViewController.h"

@interface ReportDetailViewController ()

@end

@implementation ReportDetailViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateView];
    NSLog(@"Report Detail View Updated");
}

-(void)updateView {
    
    _trainNumberLabel.text = _trainNumber;
    [_trainNumberLabel sizeToFit];
    _departStationLabel.text = _departStation;
    [_departStationLabel sizeToFit];
    _arrivStationLabel.text = _arrivStation;
    [_arrivStationLabel sizeToFit];
    _cleaningValueLabel.text = _cleaningValue;
    [_cleaningValueLabel sizeToFit];
    _stinkValueLabel.text = _stinkValue;
    [_stinkValueLabel sizeToFit];
    _crowdingValueLabel.text = _crowdingValue;
    [_crowdingValueLabel sizeToFit];
    _qualityValueLabel.text = _qualityValue;
    [_qualityValueLabel sizeToFit];
    _noiseLevelLabel.text = _noiseLevel;
    [_noiseLevelLabel sizeToFit];
    _commentValueLabel.text = _commentValue;
    [_commentValueLabel sizeToFit];
    _imageView.image = _userImage;
    [_imageView sizeToFit];
    
}

//- (void)updateTrainNumberLabel
//{
//    self.trainNumberLabel.text = self.trainNumber;
//}
//
//- (void)setTrainNumber:(NSString *)trainNumber
//{
//    self.trainNumber = trainNumber;
//    [self updateTrainNumberLabel];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setLabel:(UILabel *)myLabel withText:(NSString *)myString {
//    
//    NSLog(@"detail view train number received: %@", myString);
//    [myLabel setText:myString];
//}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

@end
