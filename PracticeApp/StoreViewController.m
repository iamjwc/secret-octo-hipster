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
@synthesize fetchedResultsController = _fetchedResultsController;


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


- (NSFetchedResultsController *)refetch {
  NSFetchRequest *fetchRequest = [Song allSortedByName];
  
  NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                            initWithFetchRequest:fetchRequest
                                            managedObjectContext:[self managedObjectContext]
                                            sectionNameKeyPath:nil
                                            cacheName:nil];
  
  controller.delegate = self;
  
  _fetchedResultsController = controller;
  return controller;
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  
  return [self refetch];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  remoteSongCollection = [[RemoteSongCollection alloc] init];
  remoteSongCollection.delegate = self;
  [remoteSongCollection updateSongsFromRemoteWithContext:[self managedObjectContext]];
  
  NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
}

- (void)songsFetched:(id)sender {
  [self refetch];
  
  NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
  
  UITableView *tableView = (UITableView *)self.view;
  [tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex: section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"StoreCell";

  
  Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  StoreCell *cell = (StoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.index = indexPath.row;
  cell.delegate = self;
  cell.label.text = song.name;
  cell.keyLabel.text = song.key;
  
  // Do not show downloadButton if you've already downladed the song.
  bool songInLibrary = song.ownedValue;
  if (songInLibrary) {
    [cell.downloadButton setHidden:YES];
  }

  return cell;
}

- (void)storeCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender {
  //RemoteSong *rs = [remoteSongs objectAtIndex:i];

  //[[Song allGlobalIds] addObject:rs.globalId];
  
  //StoreCell *cell = (StoreCell*)[[sender superview] superview];
  //[cell.downloadButton setHidden:YES];
  //[cell.downloadProgress setHidden:NO];
  
  //Song *s = [[Song alloc] initWithRemoteSong:rs andContext:[self managedObjectContext]];
  //NSError *error = nil;
  //if (![[self managedObjectContext] save:&error]) {
  //  NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
  //}
}

@end
