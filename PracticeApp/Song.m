//
//  Song.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "Song.h"


@implementation Song

static NSMutableSet *allGlobalIds = nil;

@dynamic globalId;
@dynamic name;
@dynamic tempos;

+ (NSString *)className {
  return NSStringFromClass(self.class);
}

+ (NSMutableSet*)allGlobalIds
{
  if (!allGlobalIds) {
    allGlobalIds = [[NSMutableSet alloc] initWithObjects: nil];
  }
  
  return allGlobalIds;
}

+ (void)refreshGlobalIdsWithContext:(NSManagedObjectContext*)context
{
  NSError *error = nil;
  
  NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:[self className]];
  NSArray *results = [context executeFetchRequest:fr error:&error];
  
  if (!error) {
    for (Song *s in results) {
      [allGlobalIds addObject:s.globalId];
    }
  }
}


+ (NSFetchRequest *)fetchRequest
{
  return [[NSFetchRequest alloc] initWithEntityName:[self className]];
}

+ (NSFetchRequest *)allSortedByName {
  NSFetchRequest *fr = [self fetchRequest];
 
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [fr setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  return fr;
}

- (void)clearAudioDataCache
{
  for (Tempo *t in self.tempos) {
    t.audioData = nil;
  }
}

- (id)initWithName:(NSString *)name andContext:(NSManagedObjectContext *)context {
  NSEntityDescription *entity = [NSEntityDescription entityForName:[[self class] className] inManagedObjectContext:context];

  if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
    allGlobalIds = nil;
    [self setName: name];
  }
  
  return self;
}

- (id)initWithRemoteSong:(RemoteSong*)remoteSong andContext:(NSManagedObjectContext*)context
{
  if (self = [self initWithName:remoteSong.name andContext:context]) {
    self.globalId = remoteSong.globalId;
    
    for (RemoteTempo *remoteTempo in remoteSong.tempos) {
      Tempo *t = [[Tempo alloc] initWithRemoteTempo:remoteTempo andContext:context];
      [self addTemposObject:t];
    }
  }
  
  return self;
}

- (BOOL)temposAreDownloaded
{
  BOOL val = [self.tempos count] > 0;

  for (Tempo *t in self.tempos) {
    val &= [t.downloaded boolValue];
  }
  
  return val;
}

- (NSArray *)sortedTempos
{
  NSSortDescriptor *bpm = [[NSSortDescriptor alloc] initWithKey:@"bpm" ascending:YES];
  return [self.tempos sortedArrayUsingDescriptors:[NSArray arrayWithObjects: bpm, nil]];
}

@end
