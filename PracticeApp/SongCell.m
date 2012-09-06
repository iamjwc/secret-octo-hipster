//
//  SongCell.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/5/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "SongCell.h"

@implementation SongCell

@synthesize label;
@synthesize downloadButton;
@synthesize downloadProgress;
@synthesize delegate;
@synthesize index;


- (IBAction)downloadButtonTouchUpInside:(id)sender
{
  [self.delegate songCellDownloadButtonPressedAtIndex:self.index withSender:sender];
}


@end
