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

- (void)updateSongsFromRemoteWithContext:(NSManagedObjectContext*)c;
{
  NSURL *url = [NSURL URLWithString:@"https://raw.github.com/gist/3687548/d2d2252356edf9f5a889bde5f1e713d1cbfc273a/file.json"];
  ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
  [request setDelegate:self];
  context = c;
  [request startAsynchronous];
}

- (void)updateSongsWithArray:(NSArray*)songs andContext:(NSManagedObjectContext*)context
{
  for (NSDictionary *s in songs) {
    RemoteSong *rs = [[RemoteSong alloc] initWithDictionary:s];
    
    if (![Song findByGlobalId:rs.globalId withContext:context]) {
      Song *s = [[Song alloc]  initWithRemoteSong:rs andContext:context];
    }
  }

  NSError *error = nil;
  if (![context save:&error])
  {
    NSLog(@"error");
  }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  NSString *responseJson = [request responseString];
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  parser.maxDepth = 10;
  
  NSDictionary *json = [parser objectWithString:responseJson];

  [self updateSongsWithArray:[json objectForKey:@"songs"] andContext:context];
  
  [delegate songsFetched:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSError *error = [request error];
}


@end