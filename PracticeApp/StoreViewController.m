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
  UITableView *tableView = (UITableView *)self.view;
  [tableView reloadData];
  
  //[tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  remoteSongCollection = [[RemoteSongCollection alloc] init];
  remoteSongCollection.delegate = self;
  [remoteSongCollection fetch];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (remoteSongCollection && remoteSongCollection.songs) {
    return [remoteSongCollection.songs count];
  } else {
    return 0;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  RemoteSong *rs = (RemoteSong*)[remoteSongCollection.songs objectAtIndex:indexPath.row];
  
  StoreCell *cell = (StoreCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  cell.index = indexPath.row;
  cell.delegate = self;
  cell.label.text = rs.name;
  
  return cell;
}

- (NSManagedObjectContext*)managedObjectContext {
  AppDelegate *appDel = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  return [[appDel class] managedObjectContext];
}

- (void)storeCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender {
  RemoteSong *rs = [remoteSongCollection.songs objectAtIndex:i];
  
  Song *s = [[Song alloc] initWithRemoteSong:rs andContext:[self managedObjectContext]];

  NSError *error = nil;
  if (![[self managedObjectContext] save:&error]) {
    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
  }
  

}

@end
