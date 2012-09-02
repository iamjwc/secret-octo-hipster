//
//  Song.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "Song.h"


@implementation Song

@dynamic name;
@dynamic tempos;

+ (NSString *)className {
  return NSStringFromClass(self.class);
}

+ (NSFetchRequest *)allSortedByName {
  NSFetchRequest *fr = [[NSFetchRequest alloc] initWithEntityName:[self className]];
 
  NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  [fr setSortDescriptors:[NSArray arrayWithObject:sort]];
  
  return fr;
}

- (id)initWithName:(NSString *)name andContext:(NSManagedObjectContext *)context {
  NSEntityDescription *entity = [NSEntityDescription entityForName:[[self class] className] inManagedObjectContext:context];

  if (self = [super initWithEntity:entity insertIntoManagedObjectContext:context]) {
    [self setName: name];
  }
  
  return self;
}

@end
