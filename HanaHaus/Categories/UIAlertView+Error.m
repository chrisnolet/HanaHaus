//
//  UIAlertView+Error.m
//  HanaHaus
//
//  Created by Chris Nolet on 6/7/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "UIAlertView+Error.h"

@implementation UIAlertView (Error)

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)showAlertViewWithError:(NSError *)error
{
    UIAlertView *alertView = [self alertViewWithError:error];

    [alertView show];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (UIAlertView *)alertViewWithError:(NSError *)error
{
    NSArray *messages = @[ [error localizedDescription] ?: @"An error occured.", @"Please try again later." ];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[messages componentsJoinedByString:@" "]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];

    return alertView;
}

@end
