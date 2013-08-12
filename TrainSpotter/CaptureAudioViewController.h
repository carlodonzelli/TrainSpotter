//
//  CaptureAudioViewController.h
//  TrainSpotter
//
//  Created by Carlo Donzelli on 25/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CaptureAudioViewController : ViewController <AVAudioPlayerDelegate, AVAudioRecorderDelegate>

{
@private BOOL _newRecordingAvailable;
@private int peakValue;
@private int averageValue;
    
}

@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property (weak, nonatomic) IBOutlet UILabel *peakLabel;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *peakFinalValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageFinalValueLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *equalizerBar;


- (IBAction)toggleRecording:(id)sender;
- (IBAction)togglePlaying:(id)sender;

@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) AVAudioRecorder *recorder;
@property (strong, nonatomic) NSString *recordedFilePath;
@property (strong, nonatomic) NSMutableArray *averageValues;
@property (strong, nonatomic) NSTimer *recordTime;
//@property (strong, nonatomic) NSNumber *peakFinalValue;
//@property (strong, nonatomic) NSNumber *averageFinalValue;


//OLD VERSION!!!
//@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
//@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
//
//- (IBAction)startRecording:(id)sender;
//- (IBAction)startPlaying:(id)sender;
//
//-(NSString *) audioRecordingPath;
//-(NSDictionary *) audioRecordingSettings;

@end
