//
//  NSString+Plural.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/24/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "NSString+Plural.h"

@implementation NSString (Plural)

+ (NSString *)stringWithInteger:(NSInteger)value singularTerm:(NSString *)singular pluralTerm:(NSString *)plural
{
    if (value == 1) {
        return [NSString stringWithFormat:@"1 %@", singular];
    } else {
        return [NSString stringWithFormat:@"%ld %@", value, plural];
    }
}

@end
