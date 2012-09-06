//
//  Song.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "RemoteSong.h"
#import "RemoteTempo.h"
#import "Tempo.h"


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString *globalId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSSet *tempos;

+ (NSFetchRequest *)allSortedByName;
+ (NSMutableSet*)allGlobalIds;
+ (void)refreshGlobalIdsWithContext:(NSManagedObjectContext*)context;

- (id)initWithName:(NSString *)name andContext:(NSManagedObjectContext *)context;
- (id)initWithRemoteSong:(RemoteSong*)remoteSong andContext:(NSManagedObjectContext*)context;

- (NSArray *)sortedTempos;
- (BOOL)temposAreDownloaded;

@end

@interface Song (CoreDataGeneratedAccessors)
- (void)addTemposObject:(NSManagedObject *)value;
- (void)removeTemposObject:(NSManagedObject *)value;
- (void)addTempos:(NSSet *)values;
- (void)removeTempos:(NSSet *)values;
@end
