//
//  Tempo.h
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tempo : NSManagedObject

@property (nonatomic, retain) NSNumber * bpm;
@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSNumber * downloaded;

@end
