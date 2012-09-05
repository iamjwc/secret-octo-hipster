//
//  RemoteSong.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/4/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteTempo.h"

@interface RemoteSong : NSObject

@property (retain) NSString *globalId;
@property (retain) NSString *name;
@property (retain) NSArray  *tempos;

- (id)initWithDictionary:(NSDictionary*)d;

@end
