//
//  PlayerViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController

@synthesize playPauseButton;
@synthesize progress;
@synthesize song;
@synthesize audioPlayback;

- (Tempo *)tempo
{
  return tempo;
}
- (void)setTempo:(Tempo *)t
{
  tempo = t;
  
  if (self.audioPlayback) {
    self.audioPlayback.delegate = nil;
  }
  
  self.audioPlayback = [[AudioPlayback alloc] initWithPath:tempo.path];
  self.audioPlayback.delegate = self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSString *formattedString = [NSString stringWithFormat:@"%@bpm", tempo.bpm];
  [[self navigationItem] setTitle:formattedString];
  
  [self playPause];

}

- (void)updatePlayhead
{
  float percentage = self.audioPlayback.currentTime/(float)self.audioPlayback.duration;
  [self.progress setProgress:percentage];
  
  if ([self.audioPlayback isPlaying]) {
    [self performSelector:@selector(updatePlayhead) withObject:nil afterDelay: 0.5f];
  }
}

- (void)playPause
{
  
  if (self.audioPlayback) {
    [self.audioPlayback playPause];
    
    if ([self.audioPlayback isPlaying]) {
      [self updatePlayhead];
    }
  }
}


- (IBAction)playPausePressed:(UIButton*)sender {
  if (self.audioPlayback) {
    [self playPause];
  }
}

- (void)playPauseChanged:(id)sender
{
  if (!self.audioPlayback) {
    return;
  }
  
  if ([self.audioPlayback isPlaying]) {
    [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
  } else {
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  if (self.audioPlayback) {
    [self.audioPlayback stop];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
