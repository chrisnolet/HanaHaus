//
//  ConfirmViewController.m
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

- (NSString *)bookingTypeText;
- (NSString *)numberOfPeopleText;
- (NSString *)hoursText;
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
    NSString *format = NSLocalizedString(@"You are about to book a %@ for %@, for %@.", nil);

    self.text = [NSString stringWithFormat:format, self.bookingTypeText, self.numberOfPeopleText, self.hoursText];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private methods

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)bookingTypeText
{
    return @"Single Seat";
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)numberOfPeopleText
{
    if (self.numberOfPeople == 1) {
        return @"1 person";
    } else {
        return [NSString stringWithFormat:@"%ld people", self.numberOfPeople];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)hoursText
{
    if (self.hours == 1) {
        return @"1 hour";
    } else {
        return [NSString stringWithFormat:@"%ld hours", self.hours];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setText:(NSString *)text
{
    // Create attributes
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineHeightMultiple = 1.2f;

    NSDictionary *attributes = @{ NSParagraphStyleAttributeName: paragraphStyle };

    // Set attributed text
    self.detailLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
