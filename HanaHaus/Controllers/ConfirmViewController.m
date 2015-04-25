//
//  ConfirmViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ConfirmViewController.h"
#import "NSString+Plural.h"
#import "UIButton+ActivityIndicatorView.h"

@interface ConfirmViewController ()

- (void)setText:(NSString *)text;

@end

@implementation ConfirmViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set detail text
    self.text = [NSString stringWithFormat:@"You are about to book a %@ for %@, for %@.",
                 @"Single Seat",
                 [NSString stringWithInteger:self.numberOfPeople singularTerm:@"person" pluralTerm:@"people"],
                 [NSString stringWithInteger:self.hours singularTerm:@"hour" pluralTerm:@"hours"]];
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
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString *)text
{
    // Create attributes
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineHeightMultiple = 1.3f;

    NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle };

    // Set attributed text
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (IBAction)confirmButtonPressed:(id)sender
{
    [self.confirmButton startAnimating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"CompleteSegue" sender:nil];
    });

//    NSURL *url;
//    NSDictionary *parameters;
//    NSMutableURLRequest *request;
//
//    // Step 1:
//    url = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/index.php?controller=pjFrontEnd&action=pjActionCheckAvailability"];
//
//    parameters = @{
//        @"item_id": @"91",
//        @"cnt": @"1",
//        @"date_from": @"03/30/2015",
//        @"hour_from": @"16",
//        @"minute_from": @"00",
//        @"date_to": @"03/30/2015",
//        @"hour_to": @"19",
//        @"minute_to": @"00"
//    };
//
//    request = [NSMutableURLRequest requestWithURL:url
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
//        // Step 2:
//        NSURL *url = [NSURL URLWithString:@"http://hanahaus.elasticbeanstalk.com/index.php?controller=pjFrontEnd&action=pjActionAddToCart"];
//
//        NSDictionary *parameters = @{
//            @"type": @"item",
//            @"id": @"91",
//            @"qty": @"1"
//        };
//
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
//                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                           timeoutInterval:10];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
//        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil]];
//
//        [[[NSURLSession sharedSession] dataTaskWithRequest:request
//                                         completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//            NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//            NSLog(@"Response: %@", response);
//            NSLog(@"Error: %@", error);
//        }] resume];
//    }] resume];
}

@end
