//
//  TutorialViewController.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 23/09/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "TutorialViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface TutorialViewController () {
    
    MPMoviePlayerController *moviePlayer;
}

@end

@implementation TutorialViewController

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
	// loading the video from internet and plays it
    NSURL *url = [NSURL URLWithString:@"http://carlodonzelli.com/trainspotterapp/data/teaser.m4v"];
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    
    // Remove the movie player view controller from the "playback did finish" notification observers
    [[NSNotificationCenter defaultCenter] removeObserver:moviePlayer
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    // Register this class as an observer instead
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//method to start playing video
- (IBAction)playVideo:(id)sender {
    
    moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];    
    
    // Start playback
    [moviePlayer prepareToPlay];
    [moviePlayer play];
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    MPMoviePlayerController *player = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        player.fullscreen = NO;
        [player.view removeFromSuperview];
    }
    
}

@end
