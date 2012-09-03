//
//  PlayerViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController

@synthesize playPause;
@synthesize progressSlider;
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
}


- (IBAction)playPause:(UIButton*)sender {
  if (self.audioPlayback) {
    [self.audioPlayback playPause];
  }
}

- (void)playPauseChanged:(id)sender
{
  if (!self.audioPlayback) {
    return;
  }
  
  if ([self.audioPlayback isPlaying]) {
    [self.playPause setTitle:@"Pause" forState:UIControlStateNormal];
  } else {
    [self.playPause setTitle:@"Play" forState:UIControlStateNormal];
  }
}

- (void)viewDidUnload
{
  if (self.audioPlayback) {
    [self.audioPlayback stop];
  }
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
