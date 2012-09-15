//
//  TempoView.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/6/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tempo.h"

@interface TempoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) Tempo *tempo;

- (id)initWithTempo:(Tempo*)tempo;

@end
