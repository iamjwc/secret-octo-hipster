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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  Song *s = (Song*)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  if ([s temposAreDownloaded]) {
    return indexPath;
  } else {
    SongCell *cell = (SongCell*)[tableView cellForRowAtIndexPath:indexPath];
    //[self downloadAllForSong:s atCell:cell];
    
    return nil;
  }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"PlayerSegue"]) {
    PlayerViewController *player = segue.destinationViewController;
    
    SongCell* cell = (SongCell*)sender;
    NSIndexPath* idx = [[self tableView] indexPathForCell:cell];
    
    Song *s = (Song *)[self.fetchedResultsController objectAtIndexPath:idx];
    player.song = s;
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
  //[cell.downloadProgress setHidden:[song temposAreDownloaded]];
  //[cell.downloadProgress setProgress:0.0f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"SongCell";
  SongCell *cell = (SongCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  // Set up the cell...
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return [[appDel class] managedObjectContext];
}

- (void)viewDidUnload {
  self.fetchedResultsController = nil;
}

@end
