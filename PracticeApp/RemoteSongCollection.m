//
//  RemoteSongCollection.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "RemoteSongCollection.h"

@implementation RemoteSongCollection

@synthesize delegate;
@synthesize songs;

- (id)init {
  if (self = [super init]) {
    self.songs = nil;
  }
  return self;
}

- (void)fetch
{
  NSURL *url = [NSURL URLWithString:@"http://localhost:8080/songs"];
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (NSArray*)remoteSongsWithDictionary:(NSArray*)songs
{
  NSMutableArray *remoteSongs = [[NSMutableArray alloc] init];
  for (NSDictionary *s in songs) {
    [remoteSongs addObject:[[RemoteSong alloc] initWithDictionary:s]];
  }
  
  return remoteSongs;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  NSString *responseJson = [request responseString];
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  parser.maxDepth = 10;
  
  NSDictionary *json = [parser objectWithString:responseJson];

  self.songs = [self remoteSongsWithDictionary:[json objectForKey:@"songs"]];
  
  [delegate songsFetched:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSError *error = [request error];
}


@end