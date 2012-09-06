//
//  StoreCell.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StoreCellDelegate

- (IBAction)storeCellDownloadButtonPressedAtIndex:(NSInteger)i withSender:(id)sender;

@end

@interface StoreCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *downloadButton;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) NSInteger index;

-(IBAction) buttonTouchUpInside:(id)sender;

@end
