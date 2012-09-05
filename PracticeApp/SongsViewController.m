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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  NSLog(@"%@", segue.identifier);
  
  if ([segue.identifier isEqualToString:@"BPMSegue"]) {
    BpmsViewController *detail = segue.destinationViewController;
    
    UITableViewCell* myCell = (UITableViewCell*)sender;
    NSIndexPath* idx = [[self tableView] indexPathForCell:myCell];
    
    Song *s = (Song *)[self.fetchedResultsController objectAtIndexPath:idx];
    detail.song = s;
  }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex: section];
  return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = song.name;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!cell) {
    NSLog(@"No cell found");
  }
  
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
