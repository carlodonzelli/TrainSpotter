//
//  CaptureAudioViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 25/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//
/*
 The decibels value will now be in the decibels variable.
 Now the first thing that you will notice when looking at these values is they are all negative,
 and the louder something is the closer to 0 it gets. Decibels are a relative measure, and have
 to relate to either noise or silence to be an effective tool at measuring either. In this case,
 0 represents full scale (or an incredibly loud) noise, in rare cases it can exceed 0 and go into
 the positives. -160 represents near silence.
 It’s also worth noting that decibels are not linear, they are logarithmic. This means that -80
 does not represent half way between silence and loud, it represents around 170,000 times the
 relative silence. This may seem like a lot, but also remember that silence is not a lot (around
 20 µPa), so even 170,000 times that number is still quite a relatively low number, this is also
 why it is important to make the distinction that sound isn’t measured linearly (and visual meters
 should be calibrated to reflect this).
 */


#import "CaptureAudioViewController.h"

@interface CaptureAudioViewController () {
    
    int finalSum;
}

@end

@implementation CaptureAudioViewController

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
    //defines file path for the recording
    self.recordedFilePath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"recording.wav"];
    
    //converting file path to an URL
    NSURL *url = [[NSURL alloc] initFileURLWithPath:self.recordedFilePath];
    NSError *error;
    
    //initializing audio recorder
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:nil error:&error];
    if (error)
    {
        NSLog(@"Error initializing recorder: %@", error);
    }
    self.recorder.meteringEnabled = YES;
    self.recorder.delegate = self;
    
    //initializing final data
    peakValue = -160;
    averageValue = -160;
    //_peakFinalValue = [NSNumber alloc];
    //_averageFinalValue = [NSNumber alloc];
    _averageValues = [[NSMutableArray alloc] init];
    //[self.equalizerBar setFrame:CGRectMake(0, 0, 240, 25)];
    
    //code added to add compatibility with iOS 7
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    //assures that when the user taps the Record button later, the recording will start immediately.
    [self.recorder prepareToRecord];
    //_recordTime = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
    
    NSLog(@"Successfully initialization");
}

//0 db is max power, -160 db is minimum power
-(void)updateLabels
{
    [self.recorder updateMeters];
    self.averageLabel.text = [NSString stringWithFormat:@"%f", [self.recorder averagePowerForChannel:0]];
    self.peakLabel.text = [NSString stringWithFormat:@"%f", [self.recorder peakPowerForChannel:0]];
    
    float tempPeak = [self.recorder averagePowerForChannel:0];
    self.equalizerBar.progress = (ABS(-160 - tempPeak))/160;
    NSNumber *num = [NSNumber numberWithFloat:tempPeak];
    [_averageValues addObject:num];
    
    //NSLog(@"VALUE: %d", peakValue);
    //NSLog(@"TEMP PEAK: %f", tempPeak);
    
    //update max reached peak
    if (peakValue < tempPeak) {
        peakValue = tempPeak;
        self.peakFinalValueLabel.text = [NSString stringWithFormat:@"%i", peakValue];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleRecording:(id)sender {
    
    
    if ([self.recorder isRecording])
    {
        //stop button pressed
        [self.recorder stop];
        [_recordTime invalidate];
        _recordTime = nil;
        
        //calculating final average
        NSNumber *tempNumber;
        float sum = 0;
        finalSum = 0;
        for (tempNumber in _averageValues)
        {
            int aInt = [tempNumber intValue];
            sum = sum + aInt;
        }
        finalSum = sum / [_averageValues count];
        self.averageFinalValueLabel.text =[NSString stringWithFormat:@"%i", finalSum];
        
        [self.recordButton setTitle:@"Start" forState:UIControlStateNormal];
        
        if (self.submitNoiseButton.enabled == NO) {
            [self.submitNoiseButton setEnabled:YES];
        }
        
        if (self.playButton.enabled == NO) {
            [self.playButton setEnabled:YES];
        }
    }
    else {
        //record button pressed
        [self.recorder record];
        _recordTime = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
        [self.recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        if (self.submitNoiseButton.enabled == YES) {
            [self.submitNoiseButton setEnabled:NO];
        }
        
        if (self.playButton.enabled == YES) {
            [self.playButton setEnabled:NO];
        }
    }
}

//called when a recording has finished, with a flag that indicates whether the recording was completed successfully
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    _newRecordingAvailable = flag;
    [self.recordButton setTitle:@"Start" forState:UIControlStateNormal];
}

- (IBAction)togglePlaying:(id)sender {
    
//    Never mind, I got it. If you are trying to playback a sound and its very faint then use this code - UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback; AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);AudioSessionSetActive(true);
    
    
    //if audio player is active, pause it and reset the button title to "Play"
    if (self.player.playing)
    {
        [self.player pause];
        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    }
    //else if a new recording is available, re-create the audio player with the new file
    else if (_newRecordingAvailable)
    {
        NSURL *url = [[NSURL alloc] initFileURLWithPath:self.recordedFilePath];
        NSError *error;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        if (!error)
        {
            self.player.delegate = self;
            [self.player play];
        } else {
            NSLog(@"Error initializing player: %@", error);
        }
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
        _newRecordingAvailable = NO;
    }
    //a player has been created but is not active (so it's paused) and should be restarted
    else if (self.player)
    {
        [self.player play];
        [self.playButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}


//player has finished playing the button’s title should be reset
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
}

//methods for handling interruptions for both the audio and the recorder
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        [player play];
    }
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags
{
    if (flags == AVAudioSessionInterruptionOptionShouldResume)
    {
        [recorder record];
    }
}



- (IBAction)submitNoise:(id)sender {
    
    
    NSString *userNoise = [NSString stringWithFormat: @"%i", finalSum];
    
    NSString *currentId = theAppDelegate.objectID;
    
    PFQuery *query = [PFQuery queryWithClassName:@"CheckIn"];
    [query getObjectInBackgroundWithId:currentId block:^(PFObject *feedback, NSError *error) {
        
        [feedback setObject:userNoise forKey:@"avgNoiseLevel"];
        
        [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                
                NSLog(@"User recorded %@ of noise", userNoise);
                NSLog(@"Saved in Sound Monitor View.");
                //NSLog(@"Current object ID checkin view: %@", currentId);
                
            } else {
                NSLog(@"Something wrong happened: %@", error);
            }
        }];
    }];
}

//OLD VERSION!!!
//- (IBAction)startRecording:(id)sender {
//    
//    NSError *error = nil;
//    NSString *pathAsString = [self audioRecordingPath];
//    
//    //set save path and audio settings
//    NSURL *audioRecordingURL = [NSURL fileURLWithPath:pathAsString];
//    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioRecordingURL settings:[self audioRecordingSettings] error:&error];
//    
//    if (self.audioRecorder != nil) {
//        
//        self.audioRecorder.delegate = self;
//        /* Prepare the recorder and then start the recording */
//        if ([self.audioRecorder prepareToRecord] && [self.audioRecorder record]) {
//            NSLog(@"Successfully started to record.");
//            /* After five seconds, let's stop the recording process */
//            [self performSelector:@selector(stopRecordingOnAudioRecorder:) withObject:self.audioRecorder afterDelay:5.0f];
//        } else {
//            NSLog(@"Failed to record.");
//            self.audioRecorder = nil; }
//    } else {
//        NSLog(@"Failed to create an instance of the audio recorder.");
//    }
//}
//
////method to specify the path where to save the file and filename, es: /var/mobile/Applications/ApplicationID/Documents/Recording.m4a
//- (NSString *) audioRecordingPath {
//    
//    NSString *result = nil;
//    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsFolder = [folders objectAtIndex:0]; result = [documentsFolder stringByAppendingPathComponent:@"Recording.m4a"];
//    return result;
//}
//
////audio recorder options in the dictionary. Later we will use this dictionary to instantiate an audio recorder of type AVAudioRecorder
//- (NSDictionary *) audioRecordingSettings {
//    
//    NSDictionary *result = nil;
//    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
//    
//    [settings setValue:[NSNumber numberWithInteger:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
//    [settings setValue:[NSNumber numberWithFloat:44100.0f] forKey:AVSampleRateKey];
//    [settings setValue:[NSNumber numberWithInteger:1] forKey:AVNumberOfChannelsKey];
//    [settings setValue:[NSNumber numberWithInteger:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
//    
//    result = [NSDictionary dictionaryWithDictionary:settings];
//    
//    return result;
//}
//
////stop the audio recorder
//- (void) stopRecordingOnAudioRecorder :(AVAudioRecorder *)paramRecorder {
//    
//    [paramRecorder stop];
//}
//
////
//- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
//    
//    if (flag){
//        NSLog(@"Successfully stopped the audio recording process.");
//            } else {
//        NSLog(@"Stopping the audio recording failed.");
//    }
//    /* Here we don't need the audio recorder anymore */
//    //self.audioRecorder = nil;
//}
//
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//    
//    if (flag){
//        NSLog(@"Audio player stopped correctly.");
//    } else {
//        NSLog(@"Audio player did not stop correctly.");
//    }
//    if ([player isEqual:self.audioPlayer]){ self.audioPlayer = nil;
//    } else {
//        /* This is not the player */
//    }
//}
//
//- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
//    
//    /* The audio session has been deactivated here */
//}
//
//- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
//    
//    if (flags == AVAudioSessionInterruptionFlags_ShouldResume){ [player play];
//    }
//}
//
//- (IBAction)startPlaying:(id)sender {
//    
//    //try to retrieve the data for the recorded file
//    NSError *playbackError = nil;
//    NSError *readingError = nil;
//    NSData *fileData = [NSData dataWithContentsOfFile:[self audioRecordingPath] options:NSDataReadingMapped error:&readingError];
//    
//    //creat an audio player and make it play the recorded data
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&playbackError];
//    // if audio player is ok?
//    if (self.audioPlayer != nil){ self.audioPlayer.delegate = self;
//        // Prepare to play and start playing
//        if ([self.audioPlayer prepareToPlay] && [self.audioPlayer play]) {
//            
//            NSLog(@"Started playing the recorded audio.");
//        } else {
//                NSLog(@"Could not play the audio.");
//        }
//    } else {
//        NSLog(@"Failed to create an audio player.");
//    }
//}
@end
