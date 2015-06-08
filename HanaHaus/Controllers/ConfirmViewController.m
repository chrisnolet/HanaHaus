//
//  ConfirmViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ConfirmViewController.h"
#import "AccountManager.h"
#import "NSDate+Calendar.h"
#import "NSDateFormatter+StringWithFormat.h"
#import "NSString+Plural.h"
#import "UIButton+ActivityIndicatorView.h"
#import "UIAlertView+Error.h"

@interface ConfirmViewController ()

- (void)performRequestWithUrl:(NSString *)url paramaters:(NSDictionary *)parameters completion:(void (^)())completion;
- (NSURLRequest *)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters;
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
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error) {
//                [self.confirmButton stopAnimating];
//
//                return [UIAlertView showAlertViewWithError:error];
//            }
//
//            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//
//            [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
//        }];
//    }] resume];
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)confirmButtonPressed:(id)sender
{
    [self.confirmButton startAnimating];

    AccountManager *accountManager = [[AccountManager alloc] init];
    NSDate *endDate = [self.startDate dateByAddingHours:self.hours];

    NSDictionary *reservationParameters = @{
        @"item_id": @"91",
        @"cnt": [NSString stringWithFormat:@"%ld", self.numberOfPeople],
        @"date_from": [NSDateFormatter stringFromDate:self.startDate dateFormat:@"MM/dd/yyyy"],
        @"hour_from": [NSDateFormatter stringFromDate:self.startDate dateFormat:@"H"],
        @"minute_from": [NSDateFormatter stringFromDate:self.startDate dateFormat:@"mm"],
        @"date_to": [NSDateFormatter stringFromDate:endDate dateFormat:@"MM/dd/yyyy"],
        @"hour_to": [NSDateFormatter stringFromDate:endDate dateFormat:@"H"],
        @"minute_to": [NSDateFormatter stringFromDate:endDate dateFormat:@"mm"],
    };

    NSDictionary *accountParameters = @{
        @"er_checkout": @"1",
        @"c_name": accountManager.name,
        @"c_email": accountManager.email,
        @"c_phone": accountManager.phone,
        @"c_zip": accountManager.zip,
        @"c_notes": @"Reserved via iOS app",
        @"terms": @"1"
    };

    [self performRequestWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionCheckAvailability"
           paramaters:reservationParameters
           completion:^{

        [self performRequestWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionAddToCart"
               paramaters:@{ @"type": @"item", @"id": reservationParameters[@"item_id"], @"qty": reservationParameters[@"cnt"] }
               completion:^{

            [self performRequestWithUrl:@"index.php?controller=pjFrontPublic&action=pjActionCart"
                   paramaters:@{ @"er_cart": @"1"}
                   completion:^{

                [self performRequestWithUrl:@"index.php?controller=pjFrontPublic&action=pjActionCheckout"
                       paramaters:accountParameters
                       completion:^{

                    [self performRequestWithUrl:@"index.php?controller=pjFrontEnd&action=pjActionProcessOrder"
                           paramaters:@{ @"er_preview": @"1", @"er_validate": @"1" }
                           completion:^{

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
- (void)performRequestWithUrl:(NSString *)url paramaters:(NSDictionary *)parameters completion:(void (^)())completion
{
    // Perform API call
    NSURLRequest *request = [self requestWithUrl:url parameters:parameters];

    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        // Resume on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self.confirmButton stopAnimating];

                return [UIAlertView showAlertViewWithError:error];
            }

            completion();
        });
    }] resume];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURLRequest *)requestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters
{
    // Generate POST request from relative path and parameters
    NSURL *baseUrl = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/"];
    NSString *query = [self queryForParameters:parameters];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url relativeToURL:baseUrl]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    // Return immutable copy
    return [request copy];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)queryForParameters:(NSDictionary *)parameters
{
    // Encode query fragments
    NSMutableCharacterSet *characterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [characterSet removeCharactersInString:@"&+=?"];

    // Translate parameters to query string
    NSMutableArray *parts = [NSMutableArray arrayWithCapacity:[parameters count]];

    for (NSString *key in parameters) {
        NSString *encodedKey = [key stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
        NSString *encodedValue = [parameters[key] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];

        [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }

    return [parts componentsJoinedByString:@"&"];
}

@end
