//
//  NSDate+Calendar.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/26/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSDate+Calendar.h"

@implementation NSDate (Calendar)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                   fromDate:[NSDate date]];

    return [calendar dateFromComponents:dateComponents];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDate *)dateByAddingHours:(NSInteger)hours
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = hours;

    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

@end
