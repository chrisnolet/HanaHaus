//
//  NSString+Plural.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/24/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Plural)

+ (NSString *)stringWithInteger:(NSInteger)value singularTerm:(NSString *)singular pluralTerm:(NSString *)plural;

@end
