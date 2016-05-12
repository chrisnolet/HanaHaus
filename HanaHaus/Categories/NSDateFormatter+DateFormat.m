//
//  NSDateFormatter+DateFormat.m
//  HanaHaus
//
//  Created by Chris Nolet on 6/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSDateFormatter+DateFormat.h"

@implementation NSDateFormatter (StringWithFormat)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;

    return [dateFormatter stringFromDate:date];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;

    return [dateFormatter dateFromString:string];
}

@end
