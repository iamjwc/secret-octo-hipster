//
//  RemoteTempo.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/4/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "RemoteTempo.h"

@implementation RemoteTempo

@synthesize url;
@synthesize bpm;

- (id)initWithDictionary:(NSDictionary*)rawTempo
{
  if (self = [self init]) {
    self.url = [rawTempo objectForKey:@"url"];
    self.bpm = [rawTempo objectForKey:@"bpm"];
  }
  
  return self;
}

@end
