//
//  ConfirmViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 4/2/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;
@property (strong, nonatomic) IBOutlet UILabel *startDateLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, assign) NSInteger reservationTypeIndex;
@property (nonatomic, assign) NSInteger numberOfPeople;
@property (nonatomic, assign) NSInteger hours;
@property (strong, nonatomic) NSDate *startDate;

- (IBAction)confirmButtonPressed:(id)sender;

@end
