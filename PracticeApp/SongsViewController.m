//
//  SongsViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "SongsViewController.h"

@implementation SongsViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext;// = _managedObjectContext;
@synthesize networkQueue;

- (NSFetchedResultsController *)refetch {
  NSFetchRequest *fetchRequest = [Song allSortedByName];
  
  NSFetchedResultsController *controller = [[NSFetchedResultsController alloc]
                                            initWithFetchRequest:fetchRequest
                                            managedObjectContext:self.managedObjectContext
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

- (void)downloadAllForSong:(Song*)song atCell:(SongCell*)songCell
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

  self.networkQueue.downloadProgressDelegate = songCell.downloadProgress;
  
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
  
  NSString *fileName = [NSString stringWithFormat:@"%@-%@.aiff", s.globalId, t.bpm];
  
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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSFetchedResultsController *controller = [self refetch];
  
  NSError *error = nil;
	if (![controller performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}
  
  [[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSFetchedResultsController *controller = [self refetch];
  
  NSError *error = nil;
	if (![controller performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}

  [[self tableView] reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // developer.apple.com/library/ios/#featuredarticles/ViewControllerPGforiPhoneOS/UsingViewControllersinYourApplication/UsingViewControllersinYourApplication.html
  //  [self performSegueWithIdentifier:@"BPMSegue" sender:self];
  //}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"BPMSegue"]) {
    BpmsViewController *detail = segue.destinationViewController;
    
    SongCell* cell = (SongCell*)sender;
    NSIndexPath* idx = [[self tableView] indexPathForCell:cell];
    
    Song *s = (Song *)[self.fetchedResultsController objectAtIndexPath:idx];
    detail.song = s;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex: section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(SongCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.label.text = song.name;
  cell.delegate = self;
  cell.index = indexPath.row;
  [cell.downloadButton   setHidden:[song temposAreDownloaded]];
  [cell.downloadProgress setHidden:[song temposAreDownloaded]];
  [cell.downloadProgress setProgress:0.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"SongCell";
  SongCell *cell = (SongCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  // Set up the cell...
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)songCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender
{
  Song *s = (Song*)[self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
  
  SongCell *cell = (SongCell*)[[sender superview] superview];
  [cell.downloadButton setHidden:YES];
  //[cell.downloadProgress setProgress:0.75f];
  
  [self downloadAllForSong:s atCell:cell];
}

- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return [[appDel class] managedObjectContext];
}

- (void)viewDidUnload {
  self.fetchedResultsController = nil;
}

@end
