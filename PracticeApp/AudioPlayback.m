//
//  AudioPlayback.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "AudioPlayback.h"

@implementation AudioPlayback

@synthesize wasInterrupted;
@synthesize backingTrackUrl;
@synthesize backingTrackPlayer;
@synthesize delegate;

- (id)initWithPath:(NSString *)filePath
{	
	if (self = [super init]) {
    self.backingTrackUrl = [[NSURL alloc] initFileURLWithPath:filePath];

		self.backingTrackPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self backingTrackUrl] error:nil];	
    self.backingTrackPlayer.numberOfLoops = -1;
    
    self.wasInterrupted = NO;
  }
  
  return self;
}

- (BOOL)isPlaying
{
  return self.backingTrackPlayer && [self.backingTrackPlayer isPlaying];
}

- (void)stop
{
  if (self.isPlaying) {
    [self.backingTrackPlayer stop];
  }
}

- (void)playPause
{
  if ([self isPlaying]) {
    [self.backingTrackPlayer pause];
  } else {
    [self.backingTrackPlayer play];
  }
  
  [delegate playPauseChanged:self];
}


@end

