//
//  UIAlertView+Error.h
//  HanaHaus
//
//  Created by Chris Nolet on 6/7/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Error)

+ (UIAlertView *)alertViewWithError:(NSError *)error;
+ (UIAlertView *)alertViewWithErrorMessage:(NSString *)message;

@end
