//
//  StoreViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteSongCollection.h"
#import "AppDelegate.h"
#import "Song.h"
#import "Tempo.h"
#import "StoreCell.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface StoreViewController : UITableViewController <RemoteSongCollectionDelegate, StoreCellDelegate>
{
  RemoteSongCollection *remoteSongCollection;
}

@property (nonatomic, retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
