//
//  BookingTypeManager.h
//  HanaHaus
//
//  Created by Chris Nolet on 5/19/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookingTypeManager : NSObject

@property (strong, nonatomic) NSArray *bookingTypes;

+ (instancetype)sharedInstance;

@end
