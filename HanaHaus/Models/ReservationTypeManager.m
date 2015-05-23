//
//  ReservationTypeManager.m
//  HanaHaus
//
//  Created by Chris Nolet on 5/19/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ReservationTypeManager.h"

@implementation ReservationTypeManager

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });

    return sharedInstance;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (instancetype)init
{
    self = [super init];

    if (self) {
        self.reservationTypes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ReservationTypeManager"
                                                                                                 ofType:@"plist"]];
    }

    return self;
}

@end
