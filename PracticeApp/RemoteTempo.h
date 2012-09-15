//
//  RemoteTempo.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/4/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteTempo : NSObject

@property (retain) NSString *url;
@property (retain) NSNumber *bpm;

- (id)initWithDictionary:(NSDictionary*)rawTempo;

@end
