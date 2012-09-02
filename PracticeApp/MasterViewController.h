//
//  MasterViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
