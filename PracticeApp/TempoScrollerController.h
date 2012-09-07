//
//  TempoScrollerController.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/6/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempoViewController.h"

@interface TempoScrollerController : UIViewController
{
  BOOL pageControlUsed;
  NSMutableArray *tempoViewControllers;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

@end
