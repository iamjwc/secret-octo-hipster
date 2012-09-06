//
//  SongCell.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/5/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SngCellDelegate

- (IBAction)songCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender;

@end

@interface SongCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) IBOutlet UIProgressView *downloadProgress;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) NSInteger index;

-(IBAction) downloadButtonTouchUpInside:(id)sender;

@end
