//
//  PlayerViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "Tempo.h"
#import "AudioPlayback.h"

@interface PlayerViewController : UIViewController <AudioPlaybackDelegate>
{
  Song  *song;
  Tempo *tempo;
}

@property (nonatomic, retain) IBOutlet UIButton *playPause;
@property (nonatomic, retain) IBOutlet UISlider *progressSlider;

@property (nonatomic, retain) Song *song;
@property (nonatomic, retain) Tempo *tempo;
@property (nonatomic, retain) AudioPlayback *audioPlayback;

- (IBAction)playPause:(UIButton*)sender;
- (void)playPauseChanged:(id)sender;

@end
