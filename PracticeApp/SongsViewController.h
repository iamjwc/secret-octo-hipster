//
//  SongsViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "AppDelegate.h"

@interface SongsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
