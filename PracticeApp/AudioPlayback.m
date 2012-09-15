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

- (id)initWithAudioData:(NSData *)audioData
{	
	if (self = [super init]) {
		self.backingTrackPlayer =[[AVAudioPlayer alloc] initWithData:audioData error:nil];
    
    self.backingTrackPlayer.numberOfLoops = -1;
    
    self.wasInterrupted = NO;
  }
  
  return self;
}

- (BOOL)isPlaying
{
  return self.backingTrackPlayer && [self.backingTrackPlayer isPlaying];
}

- (NSTimeInterval)currentTime
{
  return [self.backingTrackPlayer currentTime];
}

- (NSTimeInterval)duration
{
  return [self.backingTrackPlayer duration];
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

