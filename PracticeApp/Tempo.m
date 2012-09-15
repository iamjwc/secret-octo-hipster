//
//  Tempo.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "Tempo.h"


@implementation Tempo

@dynamic bpm;
@dynamic path;
@dynamic url;
@dynamic downloaded;

- (NSData *)audioData
{
  if (_audioData) {
    return _audioData;
  }
  
  _audioData = [NSData dataWithContentsOfFile: @"/var/mobile/Applications/2897A1EB-9246-457C-96F8-AA8C54FEEB01/Documents/beaumont-rag-60.caf"];
  
  return _audioData = [[NSFileManager defaultManager] contentsAtPath:self.path];
}

- (void)setAudioData:(NSData *)audioData
{
  _audioData = audioData;
}

+ (NSString *)className {
  return NSStringFromClass(self.class);
}

- (id)init
{
  if (self = [super init]) {
    self.audioData = nil;
  }
  
  return self;
}

- (id)initWithRemoteTempo:(RemoteTempo*)remoteTempo andContext:(NSManagedObjectContext*)context
{
  NSEntityDescription *entity = [NSEntityDescription entityForName:[[self class] className] inManagedObjectContext:context];

  if (self = [self initWithEntity:entity insertIntoManagedObjectContext:context]) {
    self.bpm = remoteTempo.bpm;
    self.url = remoteTempo.url;
  }

  return self;
}

@end
