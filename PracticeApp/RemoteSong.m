//
//  RemoteSong.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/4/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "RemoteSong.h"


@implementation RemoteSong

@synthesize globalId;
@synthesize name;
@synthesize key;
@synthesize tempos;

- (id)initWithDictionary:(NSDictionary*)d
{
  NSString *g = [d objectForKey:@"globalId"];
  NSString *n = [d objectForKey:@"name"];
  NSString *k = [d objectForKey:@"key"];
  NSMutableArray *ts = [[NSMutableArray alloc] init];
  
  NSArray  *rawTs = [d objectForKey:@"tempos"];
  for (NSDictionary *rawTempo in rawTs) {
    [ts addObject:[[RemoteTempo alloc] initWithDictionary:rawTempo]];
  }
  
  if (self = [self init]) {
    self.globalId    = g;
    self.name        = n;
    self.key         = k;
    self.tempos      = ts;
  }
  
  return self;
}


@end
