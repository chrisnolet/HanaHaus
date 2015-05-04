//
//  AccountManager.h
//  HanaHaus
//
//  Created by Chris Nolet on 5/4/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManager : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *zip;

+ (instancetype)sharedInstance;
- (NSString *)validate;

@end
