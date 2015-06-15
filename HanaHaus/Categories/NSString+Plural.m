//
//  NSString+Plural.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/24/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSString+Plural.h"

@implementation NSString (Plural)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString *)stringWithInteger:(NSInteger)value singularTerm:(NSString *)singular pluralTerm:(NSString *)plural
{
    return (value == 1) ? [NSString stringWithFormat:@"1 %@", singular]
                        : [NSString stringWithFormat:@"%@ %@", @(value), plural];
}

@end
