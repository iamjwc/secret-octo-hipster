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


+ (NSString *)className {
  return NSStringFromClass(self.class);
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
