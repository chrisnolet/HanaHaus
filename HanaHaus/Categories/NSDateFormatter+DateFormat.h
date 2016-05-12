//
//  NSDateFormatter+DateFormat.h
//  HanaHaus
//
//  Created by Chris Nolet on 6/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDateFormatter (DateFormat)

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat;
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

@end
