//
//  ConfirmViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <Analytics.h>
#import "ConfirmViewController.h"
#import "AccountManager.h"
#import "NSDate+BeginningOfDay.h"
#import "NSDateFormatter+StringWithFormat.h"
#import "NSString+Plural.h"
#import "UIButton+ActivityIndicatorView.h"
#import "UIAlertView+Error.h"

@interface ConfirmViewController ()

@property (strong, nonatomic) NSDictionary *eventProperties;

@end

@implementation ConfirmViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Show reservation details
    self.numberOfPeopleLabel.text = [NSString stringWithInteger:self.numberOfPeople singularTerm:@"person" pluralTerm:@"people"];
    self.hoursLabel.text = [NSString stringWithInteger:self.hours singularTerm:@"hour" pluralTerm:@"hours"];
    self.startDateLabel.text = [NSDateFormatter stringFromDate:self.startDate dateFormat:@"EEE, MMM d 'at' h:mm a"];

    // Save event properties
    self.eventProperties = @{
        @"reservationTypeIndex": @(self.reservationTypeIndex),
        @"numberOfPeople": @(self.numberOfPeople),
        @"hours": @(self.hours),
        @"startDate": @(round([self.startDate timeIntervalSinceNow] / kUnitsSecondsPerMinute))
    };

    [[SEGAnalytics sharedAnalytics] track:@"Viewed Reservation Summary" properties:self.eventProperties];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)confirmButtonPressed:(id)sender
{
    [self.confirmButton startAnimating];

    // Generate POST request
    NSURL *url = [NSURL URLWithString:@"http://hanahaus.com/reservation"];

    NSDictionary *parameters = @{
        @"seats": @(self.numberOfPeople),
        @"date": [NSDateFormatter stringFromDate:self.startDate dateFormat:@"MM/dd/yyyy"],
        @"time": [NSDateFormatter stringFromDate:self.startDate dateFormat:@"H:mm"],
        @"hours": @(self.hours)
    };

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:10];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];

    // Perform API call
    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        // Return to main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            // NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (error) {
                [self.confirmButton stopAnimating];

                [[UIAlertView alertViewWithError:error] show];

                [[SEGAnalytics sharedAnalytics] track:@"Showed Error" properties:@{
                    @"description": [error localizedDescription],
                    @"url": url,
                    @"parameters": parameters
                }];

                return;
            }

            [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];

            [[SEGAnalytics sharedAnalytics] track:@"Completed Reservation" properties:self.eventProperties];
        });
    }] resume];

    [[SEGAnalytics sharedAnalytics] track:@"Pressed Confirm Button" properties:self.eventProperties];
}

@end
