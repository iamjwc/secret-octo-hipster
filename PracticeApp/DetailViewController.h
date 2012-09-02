//
//  DetailViewController.h
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
