//
//  AccountObject.m
//  HanaHaus
//
//  Created by Chris Nolet on 5/4/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "AccountObject.h"

@implementation AccountObject

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    self = [super init];

    if (self) {
        self.name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountName];
        self.email = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountEmail];
        self.phone = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountPhone];
        self.zip = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsAccountZip];
    }

    return self;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)validate
{
    if ([self.name length] == 0) {
        return @"Name required";
    }

    if ([self.email length] == 0) {
        return @"Email required";
    }

    if ([self.phone length] == 0) {
        return @"Phone required";
    }

    if ([self.zip length] == 0) {
        return @"Zip required";
    }

    return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)save
{
    // Save account details
    [[NSUserDefaults standardUserDefaults] setObject:self.name forKey:kUserDefaultsAccountName];
    [[NSUserDefaults standardUserDefaults] setObject:self.email forKey:kUserDefaultsAccountEmail];
    [[NSUserDefaults standardUserDefaults] setObject:self.phone forKey:kUserDefaultsAccountPhone];
    [[NSUserDefaults standardUserDefaults] setObject:self.zip forKey:kUserDefaultsAccountZip];
}

@end
