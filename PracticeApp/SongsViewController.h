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
#import "BpmsViewController.h"
#import "SongCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface SongsViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) ASINetworkQueue *networkQueue;

@end
