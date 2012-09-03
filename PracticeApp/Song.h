//
//  Song.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/2/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tempos;

+ (NSFetchRequest *)allSortedByName;
- (id)initWithName:(NSString *)name andContext:(NSManagedObjectContext *)context;

- (NSArray *)sortedTempos;

@end

@interface Song (CoreDataGeneratedAccessors)
- (void)addTemposObject:(NSManagedObject *)value;
- (void)removeTemposObject:(NSManagedObject *)value;
- (void)addTempos:(NSSet *)values;
- (void)removeTempos:(NSSet *)values;
@end
