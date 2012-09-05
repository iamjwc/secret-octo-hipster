//
//  RemoteSongCollection.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "RemoteSong.h"

@protocol RemoteSongCollectionDelegate
- (void)songsFetched:(id)sender;
@end

@interface RemoteSongCollection : NSObject

@property (retain) NSArray *songs;
@property (retain) id <RemoteSongCollectionDelegate> delegate;

- (void)fetch;

@end
