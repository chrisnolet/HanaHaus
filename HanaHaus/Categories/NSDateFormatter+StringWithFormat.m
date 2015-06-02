//
//  NSDateFormatter+StringWithFormat.m
//  HanaHaus
//
//  Created by Chris Nolet on 6/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSDateFormatter+StringWithFormat.h"

@implementation NSDateFormatter (StringWithFormat)

+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;

    return [dateFormatter stringFromDate:date];
}

@end
