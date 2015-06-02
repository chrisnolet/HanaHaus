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

@end

@implementation ConfirmViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    // Show reservation details
    self.numberOfPeopleLabel.text = [NSString stringWithInteger:self.numberOfPeople singularTerm:@"person" pluralTerm:@"people"];
    self.hoursLabel.text = [NSString stringWithInteger:self.hours singularTerm:@"hour" pluralTerm:@"hours"];
    self.startDateLabel.text = [NSDateFormatter stringFromDate:self.startDate dateFormat:@"EEE, MMM d 'at' h:mm a"];
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

    NSURL *url;
    NSDictionary *parameters;
    NSMutableURLRequest *request;

    // Step 1:
    url = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/index.php?controller=pjFrontEnd&action=pjActionCheckAvailability"];

    parameters = @{
        @"item_id": @"91",
        @"cnt": @"1",
        @"date_from": @"03/30/2015",
        @"hour_from": @"16",
        @"minute_from": @"00",
        @"date_to": @"03/30/2015",
        @"hour_to": @"19",
        @"minute_to": @"00"
    };

    request = [NSMutableURLRequest requestWithURL:url
                                      cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                  timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"Response: %@", response);
        NSLog(@"Error: %@", error);

        // Step 2:
        NSURL *url = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/index.php?controller=pjFrontEnd&action=pjActionAddToCart"];

        NSDictionary *parameters = @{
            @"type": @"item",
            @"id": @"91",
            @"qty": @"1"
        };

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];

        [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            NSLog(@"Response: %@", response);
            NSLog(@"Error: %@", error);
        }] resume];
    }] resume];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//- (IBAction)confirmButtonPressed:(id)sender
//{
//    [self.confirmButton startAnimating];
//
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
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postToUrl:(NSString *)url paramaters:(NSDictionary *)parameters
{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
//
//    [[[NSURLSession sharedSession] dataTaskWithRequest:request
//                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                                         NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//                                         NSLog(@"Response: %@", response);
//                                         NSLog(@"Error: %@", error);
//
//                                         [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
//                                     }] resume];
}

@end
