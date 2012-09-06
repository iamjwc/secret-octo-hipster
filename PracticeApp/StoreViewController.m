//
//  StoreViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "StoreViewController.h"


@implementation StoreViewController

- (void)songsFetched:(id)sender {
  [remoteSongs removeAllObjects];
  [remoteSongs addObjectsFromArray:remoteSongCollection.songs];
  
  UITableView *tableView = (UITableView *)self.view;
  [tableView reloadData];
  
  //[tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return [[appDel class] managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  remoteSongs = [[NSMutableArray alloc] initWithCapacity:0];
  
  remoteSongCollection = [[RemoteSongCollection alloc] init];
  remoteSongCollection.delegate = self;
  [remoteSongCollection fetch];
  
  [Song refreshGlobalIdsWithContext:[self managedObjectContext]];
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
  static NSString *CellIdentifier = @"Cell";
  
  RemoteSong *rs = (RemoteSong*)[remoteSongs objectAtIndex:indexPath.row];
  
  StoreCell *cell = (StoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.index = indexPath.row;
  cell.delegate = self;
  cell.label.text = rs.name;
  
  // Do not show downloadButton if you've already downladed the song.
  if ([[Song allGlobalIds] containsObject:rs.globalId]) {
    [cell.downloadButton setHidden:YES];
  }
  
  
  return cell;
}

- (void)storeCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender {
  RemoteSong *rs = [remoteSongs objectAtIndex:i];
  
  // Remove RemoteSong from array then remove it from the table;
  //[remoteSongs removeObjectAtIndex:i];
  //NSArray *a = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:i inSection:1], nil];
  //[self.tableView deleteRowsAtIndexPaths:a withRowAnimation:UITableViewRowAnimationFade];

  [[Song allGlobalIds] addObject:rs.globalId];
  
  StoreCell *cell = (StoreCell*)[[sender superview] superview];
  [cell.downloadButton setHidden:YES];
  
  Song *s = [[Song alloc] initWithRemoteSong:rs andContext:[self managedObjectContext]];
  NSError *error = nil;
  if (![[self managedObjectContext] save:&error]) {
    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
  }
  

}

@end
