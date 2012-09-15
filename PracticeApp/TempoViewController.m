//
//  TempoView.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/6/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "TempoViewController.h"

@implementation TempoViewController

@synthesize label;
@synthesize tempo;

- (id)initWithTempo:(Tempo*)tempo
{
  if (self = [super initWithNibName:@"TempoView" bundle:nil]) { 
    self.tempo = tempo;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.label.text = [NSString stringWithFormat:@"%@ bpm", tempo.bpm];
}

@end
