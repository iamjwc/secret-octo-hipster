//
//  StoreViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "StoreViewController.h"


@implementation StoreViewController

@synthesize networkQueue;


- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return [[appDel class] managedObjectContext];
}

- (void)downloadAllForSong:(Song*)song atCell:(StoreCell*)storeCell
{
  if (song.temposAreDownloaded) {
    return;
  }
  
  [self.networkQueue cancelAllOperations];
  
  // Creating a new queue each time we use it means we don't have to worry about clearing delegates or resetting progress tracking
  self.networkQueue = [ASINetworkQueue queue];
  self.networkQueue.delegate = self;
  self.networkQueue.requestDidFinishSelector = @selector(requestFinished:);
  self.networkQueue.requestDidFailSelector = @selector(requestFailed:);
  self.networkQueue.queueDidFinishSelector = @selector(queueFinished:);
  self.networkQueue.showAccurateProgress = true;
  
  self.networkQueue.downloadProgressDelegate = storeCell.downloadProgress;
  
  for (Tempo* t in song.sortedTempos) {
    if (!t.downloaded) {
      ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:t.url]];
      request.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:song, @"song", t, @"tempo", nil];
      [self.networkQueue addOperation:request];
    }
  }
  
  [self.networkQueue go];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
	if ([self.networkQueue requestsCount] == 0) {
		self.networkQueue = nil;
	}
  
  Song *s = [request.userInfo objectForKey:@"song"];
  Tempo *t = [request.userInfo objectForKey:@"tempo"];
  
  NSString *fileName = [NSString stringWithFormat:@"%@-%@.caf", s.globalId, t.bpm];
  
  NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
  [request.responseData writeToFile:appFile atomically:YES];
  
  NSLog(@"%@",documentsDirectory);
  
  t.downloaded = [NSNumber numberWithBool:true];
  t.path = appFile;
  
  NSError *error;
  [[self managedObjectContext] save:&error];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if ([self.networkQueue requestsCount] == 0) {
		self.networkQueue = nil;
	}
  
	//... Handle failure
	NSLog(@"Request failed");
}

- (void)queueFinished:(ASINetworkQueue *)queue
{
	if ([self.networkQueue requestsCount] == 0) {
		self.networkQueue = nil;
	}
  
	NSLog(@"Queue finished");
}

- (void)viewDidLoad
{
  [Song refreshGlobalIdsWithContext:[self managedObjectContext]];
}

- (void)songsFetched:(id)sender {
  //[remoteSongs removeAllObjects];
  //[remoteSongs addObjectsFromArray:remoteSongCollection.songs];
  
  UITableView *tableView = (UITableView *)self.view;
  [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  remoteSongs = [[NSMutableArray alloc] initWithCapacity:0];
  
  remoteSongCollection = [[RemoteSongCollection alloc] init];
  remoteSongCollection.delegate = self;
  //[remoteSongCollection fetch];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [remoteSongs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"StoreCell";

  RemoteSong *rs = (RemoteSong*)[remoteSongs objectAtIndex:indexPath.row];
  
  StoreCell *cell = (StoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.index = indexPath.row;
  cell.delegate = self;
  cell.label.text = rs.name;
  cell.keyLabel.text = rs.key;
  
  // Do not show downloadButton if you've already downladed the song.
  bool songInLibrary = [[Song allGlobalIds] containsObject:rs.globalId];
  if (songInLibrary) {
    [cell.downloadButton setHidden:YES];
  }

  return cell;
}

- (void)storeCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender {
  RemoteSong *rs = [remoteSongs objectAtIndex:i];

  [[Song allGlobalIds] addObject:rs.globalId];
  
  StoreCell *cell = (StoreCell*)[[sender superview] superview];
  [cell.downloadButton setHidden:YES];
  [cell.downloadProgress setHidden:NO];
  
  Song *s = [[Song alloc] initWithRemoteSong:rs andContext:[self managedObjectContext]];
  NSError *error = nil;
  if (![[self managedObjectContext] save:&error]) {
    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
  }
  

}

@end
