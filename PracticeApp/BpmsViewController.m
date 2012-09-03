//
//  DetailViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "BpmsViewController.h"

@implementation BpmsViewController

@synthesize song;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[self navigationItem] setTitle:song.name];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  NSLog(@"%@", segue.identifier);
  
  if ([segue.identifier isEqualToString:@"PlayerSegue"]) {
    PlayerViewController *player = segue.destinationViewController;
    
    UITableViewCell* myCell = (UITableViewCell*)sender;
    NSIndexPath* idx = [[self tableView] indexPathForCell:myCell];
    
    player.song = self.song;
    player.tempo = (Tempo *)[[self.song sortedTempos] objectAtIndex:[idx row]];
  }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self.song sortedTempos] count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  //Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  Tempo *t = [[self.song sortedTempos] objectAtIndex:[indexPath row]];
  
  cell.textLabel.text = [NSString stringWithFormat:@"%@", t.bpm];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"BPMCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  // Set up the cell...
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}


@end
