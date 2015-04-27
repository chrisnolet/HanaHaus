//
//  BookingViewController.h
//  HanaHaus
//
//  Created by Chris Nolet on 3/28/15.
//  Copyright (c) 2015 Relaunch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableViewCell *bookingTypeCell;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPeopleLabel;
@property (strong, nonatomic) IBOutlet UIStepper *numberOfPeopleStepper;
@property (strong, nonatomic) IBOutlet UILabel *hoursLabel;
@property (strong, nonatomic) IBOutlet UIStepper *hoursStepper;
@property (strong, nonatomic) IBOutlet UITableViewCell *datePickerCell;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)stepperValueDidChange:(id)sender;
- (IBAction)datePickerValueDidChange:(id)sender;
- (IBAction)accountButtonPressed:(id)sender;
- (IBAction)continueButtonPressed:(id)sender;
- (IBAction)unwindFromAccount:(UIStoryboardSegue *)unwindSegue;
- (IBAction)unwindFromBookingType:(UIStoryboardSegue *)unwindSegue;

@end
