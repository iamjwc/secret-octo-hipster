//
//  DetailViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController

@synthesize song;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [[self navigationItem] setTitle:song.name];
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
  return [[self.song tempos] count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  //Song *song = (Song *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  
  Tempo *t = [[self.song.tempos allObjects] objectAtIndex:[indexPath row]];
  
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
