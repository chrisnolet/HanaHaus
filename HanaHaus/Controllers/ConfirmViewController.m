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

- (void)postWithUrl:(NSString *)url paramaters:(NSDictionary *)parameters completion:(HTTPCompletionBlock)completion;
- (NSString *)queryForParameters:(NSDictionary *)parameters;

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
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
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
- (IBAction)confirmButtonPressed:(id)sender
{
    [self.confirmButton startAnimating];

    NSDictionary *reservation = @{
        @"item_id": @"91",
        @"cnt": @"1",
        @"date_from": @"06/07/2015",
        @"hour_from": @"16",
        @"minute_from": @"00",
        @"date_to": @"06/07/2015",
        @"hour_to": @"17",
        @"minute_to": @"00"
    };

    NSDictionary *account = @{
        @"er_checkout": @"1",
        @"c_name": @"Example",
        @"c_email": @"example@example.com",
        @"c_phone": @"(650) 555-0100",
        @"c_zip": @"94301",
        @"c_notes": @"Please delete this booking!",
        @"terms": @"1"
    };

    [self postWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionCheckAvailability"
           paramaters:reservation
           completion:^(NSDictionary *results) {

        [self postWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionAddToCart"
               paramaters:@{ @"type": @"item", @"id": @"91", @"qty": @"1" }
               completion:^(NSDictionary *results) {

            [self postWithUrl:@"index.php?controller=pjFrontPublic&action=pjActionCart"
                   paramaters:@{ @"er_cart": @"1"}
                   completion:^(NSDictionary *results) {

                [self postWithUrl:@"index.php?controller=pjFrontPublic&action=pjActionCheckout"
                       paramaters:account
                       completion:^(NSDictionary *results) {

                    [self postWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionProcessOrder"
                           paramaters:@{ @"er_preview": @"1", @"er_validate": @"1" }
                           completion:^(NSDictionary *results) {

                       [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
                    }];
                }];
            }];
        }];
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)postWithUrl:(NSString *)url paramaters:(NSDictionary *)parameters completion:(HTTPCompletionBlock)completion
{
    // Perform HTTP POST to endpoint
    NSURL *baseUrl = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/"];
    NSString *query = [self queryForParameters:parameters];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:baseUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding];

    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    NSLog(@"Headers: %@", request.allHTTPHeaderFields);
    NSLog(@"Body: %@", query);

    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"Response: %@", response);
        NSLog(@"Error: %@", error);

        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

        completion(results);
    }] resume];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)queryForParameters:(NSDictionary *)parameters
{
    // Translate parameters to query string
    NSMutableArray *components = [NSMutableArray arrayWithCapacity:[parameters count]];

    for (NSString *key in parameters) {
        [components addObject:[NSString stringWithFormat:@"%@=%@", key, parameters[key]]];
    }

    return [components componentsJoinedByString:@"&"];
}

@end
