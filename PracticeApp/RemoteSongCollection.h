//
//  RemoteSongCollection.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"


@protocol RemoteSongCollectionDelegate
- (void)songsFetched:(id)sender;
@end

@interface RemoteSongCollection : NSObject <NSURLConnectionDelegate>
{
  NSURLConnection *connection;
  NSMutableData *data;
}

@property (nonatomic, retain) NSDictionary *json;
@property (nonatomic, retain) id <RemoteSongCollectionDelegate> delegate;

- (void)getAvailableSongs;

@end
