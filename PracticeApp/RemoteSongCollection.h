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

#import "Song.h"
#import "RemoteSong.h"

@protocol RemoteSongCollectionDelegate
- (void)songsFetched:(id)sender;
@end

@interface RemoteSongCollection : NSObject
{
  NSManagedObjectContext *context;
}

@property (retain) id <RemoteSongCollectionDelegate> delegate;

- (void)updateSongsFromRemoteWithContext:(NSManagedObjectContext*)context;

@end
