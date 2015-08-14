//
//  AppDelegate.m
//  HanaHaus
//
//  Created by Chris Nolet on 3/28/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <Analytics.h>
#import "AppDelegate.h"

@implementation AppDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIApplicationDelegate

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize Segment
    [SEGAnalytics setupWithConfiguration:[SEGAnalyticsConfiguration configurationWithWriteKey:kSegmentKey]];

    // Track opens
    [[SEGAnalytics sharedAnalytics] track:@"Opened App"];

    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Track re-opens
    [[SEGAnalytics sharedAnalytics] track:@"Opened App"];
}

@end
