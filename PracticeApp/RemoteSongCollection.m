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
@synthesize json;

- (void)getAvailableSongs
{
  NSURL *url = [NSURL URLWithString:@"http://localhost:8080/songs"];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  
  connection = [NSURLConnection connectionWithRequest:request delegate:self];
  data = [NSMutableData data];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  // This method is called when the server has determined that it
  // has enough information to create the NSURLResponse.
  
  // It can be called multiple times, for example in the case of a
  // redirect, so each time we reset the data.
  
  // receivedData is an instance variable declared elsewhere.
  [data setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d
{
  // Append the new data to receivedData.
  // receivedData is an instance variable declared elsewhere.
  [data appendData:d];
}



- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
  connection = nil;
  data = nil;
  
  // inform the user
  NSLog(@"Connection failed! Error - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  // do something with the data
  // receivedData is declared as a method instance elsewhere
  NSLog(@"Succeeded! Received %d bytes of data",[data length]);
  
  
  NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  SBJsonParser *parser = [[SBJsonParser alloc] init];
  parser.maxDepth = 10;
  
  self.json = (NSMutableDictionary *)[parser objectWithString:s];

  [delegate songsFetched:self];
}

@end
