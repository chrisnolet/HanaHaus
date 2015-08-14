//
//  NSDate+BeginningOfDay.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/26/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSDate+BeginningOfDay.h"

@implementation NSDate (BeginningOfDay)

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

@end
