//
//  Tempo.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RemoteTempo.h"

@interface Tempo : NSManagedObject

@property (nonatomic, retain) NSNumber * bpm;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * downloaded;

- (id)initWithRemoteTempo:(RemoteTempo*)remoteSong andContext:(NSManagedObjectContext*)context;

@end
