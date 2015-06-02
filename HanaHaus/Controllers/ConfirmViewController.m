//
//  ConfirmViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ConfirmViewController.h"
#import "NSDateFormatter+StringWithFormat.h"
#import "NSString+Plural.h"
#import "UIButton+ActivityIndicatorView.h"

@interface ConfirmViewController ()

- (void)updateText;

@end

@implementation ConfirmViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [self updateText];
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

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
    });

//    NSURL *url = [NSURL URLWithString:@"http://hanahaus.com/reservation"];
//
//    NSDictionary *parameters = @{
//        @"seats": @(self.numberOfPeople),
//        @"date": [NSDateFormatter stringFromDate:self.startDate dateFormat:@""],
//        @"hours": @(self.hours)
//    };
//
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                  timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request
//                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//        NSLog(@"Response: %@", response);
//        NSLog(@"Error: %@", error);
//
//        [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
//    }] resume];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateText
{
    // Show reservation details
    self.numberOfPeopleLabel.text = [NSString stringWithInteger:self.numberOfPeople singularTerm:@"person" pluralTerm:@"people"];
    self.hoursLabel.text = [NSString stringWithInteger:self.hours singularTerm:@"hour" pluralTerm:@"hours"];
    self.startDateLabel.text = [NSDateFormatter stringFromDate:self.startDate dateFormat:@"EEE, MMM d 'at' h:mm a"];
}

@end
