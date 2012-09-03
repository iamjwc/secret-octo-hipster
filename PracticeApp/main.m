//
//  main.m
//  PracticeApp
//
//  Created by Justin Camerer on 8/23/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
      @try {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
      }
      @catch (NSException *exception) {
        NSLog(@"asdf");
      }
      return 1;
    }
}
