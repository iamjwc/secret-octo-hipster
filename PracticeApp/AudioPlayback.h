//
//  AudioPlayback.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol AudioPlaybackDelegate
- (void)playPauseChanged:(id)sender;
@end

@interface AudioPlayback : NSObject

@property (nonatomic, retain) NSURL                 *backingTrackUrl;
@property (nonatomic, retain, strong) AVAudioPlayer *backingTrackPlayer;
@property (nonatomic, assign) id  <AudioPlaybackDelegate> delegate; 

@property (nonatomic, assign)	BOOL wasInterrupted;		// Whether playback was interrupted by the system

- (id)initWithPath:(NSString *)filePath;
- (BOOL)isPlaying;
- (void)playPause;
- (void)stop;

@end
