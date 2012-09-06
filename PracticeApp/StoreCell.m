//
//  StoreCell.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "StoreCell.h"

@implementation StoreCell

@synthesize label;
@synthesize downloadButton;
@synthesize delegate;
@synthesize index;

- (IBAction)buttonTouchUpInside:(id)sender
{
  [self.delegate storeCellDownloadButtonPressedAtIndex:self.index withSender:sender];
}

@end
