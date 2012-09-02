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
@synthesize managedObjectContext = _managedObjectContext;

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

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

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSError *error = nil;
  
  NSFetchedResultsController *controller = self.fetchedResultsController;
  
	if (![controller performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
  
  self.title = @"Songs";
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//  return [[self.fetchedResultsController sections] count];
//}

- (void)refreshDisplay:(UITableView *)tableView {
  NSString *a;
  a = @"asdf";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  id <NSFetchedResultsSectionInfo> sectionInfo;
  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex: section];
  NSInteger b;
  b = [sectionInfo numberOfObjects];
  
  return b;
           //return [[self.fetchedResultsController sections] count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  cell.textLabel.text = song.name;  
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"Cell";
  
  //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  // Set up the cell...
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return appDel.managedObjectContext;
}

- (void)viewDidUnload {
  self.fetchedResultsController = nil;
}

@end
