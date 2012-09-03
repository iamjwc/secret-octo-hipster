//
//  StoreViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteSongCollection.h"

@interface StoreViewController : UITableViewController <RemoteSongCollectionDelegate>
{
  RemoteSongCollection *remoteSongCollection;
}

@end
