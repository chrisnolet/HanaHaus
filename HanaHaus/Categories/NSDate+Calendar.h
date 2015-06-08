//
//  NSDate+Calendar.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/26/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Calendar)

- (NSDate *)beginningOfDay;
- (NSDate *)dateByAddingHours:(NSInteger)hours;

@end
