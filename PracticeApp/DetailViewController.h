//
//  DetailViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "AppDelegate.h"

@interface DetailViewController : UITableViewController

@property (strong, nonatomic) Song *song;

@end
